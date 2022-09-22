// dart async library we will refer to when setting up real time updates
import 'dart:async';

// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

// amplify configuration and models that should have been generated for you
import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Enquiries',
      home: EnquiriesPage(),
    );
  }
}

class EnquiriesPage extends StatefulWidget {
  const EnquiriesPage({Key? key}) : super(key: key);

  @override
  State<EnquiriesPage> createState() => _EnquiriesPageState();
}

class _EnquiriesPageState extends State<EnquiriesPage> {
  @override
  void initState() {
    // to be filled in a later step
    super.initState();
  }

  @override
  void dispose() {
    // to be filled in a later step
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // to be filled in a later step
  }

  Future<void> _configureAmplify() async {
    // to be filled in a later step
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquiries'),
      ),
      body: const Center(child: CircularProgressIndicator()),
      // body: _isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : TodosList(todos: _todos),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEnquiryForm()),
          );
        },
        tooltip: 'Enquire',
        label: Row(
          children: const [Icon(Icons.add), Text('Add Enquiry')],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class EnquiriesList extends StatelessWidget {
  const EnquiriesList({
    required this.enquiries,
    Key? key,
  }) : super(key: key);

  final List<Enquiry> enquiries;

  @override
  Widget build(BuildContext context) {
    return enquiries.isNotEmpty
        ? ListView(
        padding: const EdgeInsets.all(8),
        children: enquiries.map((enquiry) => EnquiryItem(enquiry: enquiry)).toList())
        : const Center(
      child: Text('Tap button below to add a todo!'),
    );
  }
}

class EnquiryItem extends StatelessWidget {
  const EnquiryItem({
    required this.enquiry,
    Key? key,
  }) : super(key: key);

  final double iconSize = 24.0;
  final Enquiry enquiry;

  void _deleteEnquiry (BuildContext context) async {
    // to be filled in a later step
  }

  Future<void> _toggleIsComplete() async {
    // to be filled in a later step
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _toggleIsComplete();
        },
        onLongPress: () {
          _deleteEnquiry(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enquiry.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(enquiry.description ?? 'No description'),
                ],
              ),
            ),
            Icon(
                enquiry.isComplete
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: iconSize),
          ]),
        ),
      ),
    );
  }
}

class AddEnquiryForm extends StatefulWidget {
  const AddEnquiryForm({Key? key}) : super(key: key);

  @override
  State<AddEnquiryForm> createState() => _AddEnquiryFormState();
}

class _AddEnquiryFormState extends State<AddEnquiryForm> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _saveEnquiry() async {
    // to be filled in a later step
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Enquiry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                const InputDecoration(filled: true, labelText: 'Name'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    filled: true, labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: _saveEnquiry,
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}