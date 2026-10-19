import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const CRUDApp());
}

class CRUDApp extends StatelessWidget {
  const CRUDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
      ),
      home: LoginScreen(),
    );
  }
}

// ========== ITEM MODEL ==========
class Item {
  final int id;
  final String name;
  final String description;
  final double weight;
  final String? imagePath;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.weight,
    this.imagePath,
  });
}

// ========== LOGIN SCREEN ==========
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return HomeScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 60,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // App Name
                    const Text(
                      'CRUD App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Inventory Management System',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Username Field
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Demo Credentials
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Text('Default: admin / admin123'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (_usernameController.text == 'admin' && 
                              _passwordController.text == 'admin123') {
                            setState(() {
                              _isLoggedIn = true;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid credentials'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========== HOME SCREEN ==========
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];
  int nextId = 1;

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete "${items[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD App - Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No items yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  const Text('Tap + to add your first item'),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditScreen(
                            item: null,
                            onSave: (newItem) {
                              setState(() {
                                items.add(newItem);
                                nextId++;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Item'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                image: item.imagePath != null
                                    ? DecorationImage(
                                        image: FileImage(File(item.imagePath!)),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: item.imagePath == null
                                  ? const Center(
                                      child: Icon(
                                        Icons.photo,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            
                            // Item Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ID: ${item.id}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${item.weight} kg',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddEditScreen(
                                        item: item,
                                        onSave: (updatedItem) {
                                          setState(() {
                                            items[index] = updatedItem;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'EDIT',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[50],
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () => _showDeleteDialog(index),
                              child: const Text('DELETE'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditScreen(
                item: null,
                onSave: (newItem) {
                  setState(() {
                    items.add(newItem);
                    nextId++;
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ========== ADD/EDIT SCREEN ==========
class AddEditScreen extends StatefulWidget {
  final Item? item;
  final Function(Item) onSave;

  const AddEditScreen({
    super.key,
    required this.item,
    required this.onSave,
  });

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Track validation states
  bool _isIdValid = true;
  bool _isNameValid = true;
  bool _isDescValid = true;
  bool _isWeightValid = true;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _idController.text = widget.item!.id.toString();
      _nameController.text = widget.item!.name;
      _descController.text = widget.item!.description;
      _weightController.text = widget.item!.weight.toString();
    } else {
      _idController.text = '';
    }
    
    // Add listeners for real-time validation
    _idController.addListener(_validateIdRealTime);
    _nameController.addListener(_validateNameRealTime);
    _descController.addListener(_validateDescRealTime);
    _weightController.addListener(_validateWeightRealTime);
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // Real-time validation for Item ID
  void _validateIdRealTime() {
    final value = _idController.text;
    setState(() {
      if (value.isEmpty) {
        _isIdValid = false;
      } else {
        _isIdValid = RegExp(r'^[0-9]+$').hasMatch(value);
      }
    });
  }

  // Real-time validation for Item Name
  void _validateNameRealTime() {
    final value = _nameController.text.trim();
    setState(() {
      if (value.isEmpty) {
        _isNameValid = false;
      } else {
        _isNameValid = RegExp(r'^[a-zA-Z\s]+$').hasMatch(value) && value.length >= 2;
      }
    });
  }

  // Real-time validation for Description
  void _validateDescRealTime() {
    final value = _descController.text.trim();
    setState(() {
      _isDescValid = value.length >= 10;
    });
  }

  // Real-time validation for Weight
  void _validateWeightRealTime() {
    final value = _weightController.text;
    setState(() {
      if (value.isEmpty) {
        _isWeightValid = false;
      } else {
        final weight = double.tryParse(value);
        _isWeightValid = weight != null && weight > 0;
      }
    });
  }

  // Final validation before save
  String? _validateId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Item ID is required';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Item ID must contain only numbers';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Item Name is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Item Name must contain only letters (A-Z, a-z)';
    }
    if (value.trim().length < 2) {
      return 'Item Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Weight is required';
    }
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveItem() {
    // Validate all form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create item
    final newItem = Item(
      id: int.parse(_idController.text),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      weight: double.parse(_weightController.text),
      imagePath: _selectedImage?.path ?? widget.item?.imagePath,
    );

    widget.onSave(newItem);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newItem.name} saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Item - CRUD App' : 'Edit Item - CRUD App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Item ID Field
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Item ID *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isIdValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isIdValid ? Colors.blue : Colors.red,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  hintText: 'Enter numbers only (e.g., 101)',
                  suffixIcon: Icon(
                    _isIdValid ? Icons.check_circle : Icons.error,
                    color: _isIdValid ? Colors.green : Colors.red,
                  ),
                  prefixIcon: const Icon(Icons.numbers, color: Colors.blue),
                  errorText: _isIdValid ? null : 'Numbers only (0-9)',
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
                readOnly: widget.item != null,
                keyboardType: TextInputType.number,
                validator: _validateId,
                onChanged: (value) => _validateIdRealTime(),
              ),
              const SizedBox(height: 20),
              
              // Item Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isNameValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isNameValid ? Colors.blue : Colors.red,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  hintText: 'Letters only (e.g., Laptop)',
                  suffixIcon: Icon(
                    _isNameValid ? Icons.check_circle : Icons.error,
                    color: _isNameValid ? Colors.green : Colors.red,
                  ),
                  prefixIcon: const Icon(Icons.abc, color: Colors.blue),
                  errorText: _isNameValid ? null : 'Letters only (A-Z, a-z)',
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                  helperText: 'Min 2 letters, no numbers/symbols',
                  helperStyle: TextStyle(
                    fontSize: 12,
                    color: _isNameValid ? Colors.grey : Colors.red,
                  ),
                ),
                validator: _validateName,
                onChanged: (value) => _validateNameRealTime(),
              ),
              const SizedBox(height: 20),
              
              // Description Field
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isDescValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isDescValid ? Colors.blue : Colors.red,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  hintText: 'Enter description (any characters allowed)',
                  suffixIcon: Icon(
                    _isDescValid ? Icons.check_circle : Icons.error,
                    color: _isDescValid ? Colors.green : Colors.red,
                  ),
                  prefixIcon: const Icon(Icons.description, color: Colors.blue),
                  errorText: _isDescValid ? null : 'Min 10 characters required',
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                  helperText: '${_descController.text.length}/10 characters',
                  helperStyle: TextStyle(
                    fontSize: 12,
                    color: _isDescValid ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: _validateDescription,
                onChanged: (value) => _validateDescRealTime(),
              ),
              const SizedBox(height: 20),
              
              // Weight Field
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Weight (kg) *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isWeightValid ? Colors.grey : Colors.red,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _isWeightValid ? Colors.blue : Colors.red,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  hintText: 'Enter weight (e.g., 2.5)',
                  suffixText: 'kg',
                  suffixIcon: Icon(
                    _isWeightValid ? Icons.check_circle : Icons.error,
                    color: _isWeightValid ? Colors.green : Colors.red,
                  ),
                  prefixIcon: const Icon(Icons.scale, color: Colors.blue),
                  errorText: _isWeightValid ? null : 'Must be a number > 0',
                  errorStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
                validator: _validateWeight,
                onChanged: (value) => _validateWeightRealTime(),
              ),
              const SizedBox(height: 20),
              
              // Image Section (OPTIONAL)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Item Image',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '(Optional)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      // Image Preview
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : widget.item?.imagePath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(widget.item!.imagePath!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.photo_camera_outlined,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Tap to select image',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '(Optional)',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // Upload Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            foregroundColor: Colors.blue,
                          ),
                          onPressed: _pickImage,
                          icon: const Icon(Icons.upload),
                          label: const Text('Select Image (Optional)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Validation Summary
              if (!_isIdValid || !_isNameValid || !_isDescValid || !_isWeightValid)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[100]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Please fix all errors before saving',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isIdValid && _isNameValid && _isDescValid && _isWeightValid
                      ? _saveItem
                      : null,
                  child: Text(
                    widget.item == null ? 'SAVE ITEM' : 'UPDATE ITEM',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}