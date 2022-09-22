// dart async library we will refer to when setting up real time updates
import 'dart:async';

// flutter and ui libraries
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
// import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

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
  late StreamSubscription<QuerySnapshot<Enquiry>> _subscription;


  // loading ui state - initially set to a loading state
  bool _isLoading = true;

  // list of Todos - initially empty
  List<Enquiry> _enquiries = [];

  // amplify plugins
  final _dataStorePlugin = AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();



  @override
  void initState() {

    // kick off app initialization
    _initializeApp();

    super.initState();
  }

  @override
  void dispose() {
    // to be filled in a later step
    super.dispose();
  }

  Future<void> _initializeApp() async {


    // configure Amplify
    await _configureAmplify();

    // Query and Observe updates to Todo models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Todo models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _todos is set to the value in the latest snapshot
    _subscription = Amplify.DataStore.observeQuery(Enquiry.classType)
        .listen((QuerySnapshot<Enquiry> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _enquiries = snapshot.items;
      });
    });
    // to be filled in a later step
  }

  Future<void> _configureAmplify() async {

    try {

      // add Amplify plugins
      await Amplify.addPlugins([_dataStorePlugin, _apiPlugin, _authPlugin]);

      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
    } catch (e) {

      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print('An error occurred while configuring Amplify: $e');
    }


    // to be filled in a later step
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquiries'),
      ),
      // body: const Center(child: CircularProgressIndicator()),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : EnquiriesList(enquiries: _enquiries),
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

    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(enquiry);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
    // to be filled in a later step
  }

  Future<void> _toggleIsComplete() async {

    // copy the Todo we wish to update, but with updated properties
    final updatedEnquiry = enquiry.copyWith(isComplete: !enquiry.isComplete);
    try {

      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedEnquiry);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
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

    final name = _nameController.text;
    final description = _descriptionController.text;

    // create a new Todo from the form values
    // `isComplete` is also required, but should start false in a new Todo
    final newEnquiry = Enquiry(
      name: name,
      description: description.isNotEmpty ? description : null,
      isComplete: false,
    );

    try {
      // to write data to DataStore, we simply pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(newEnquiry);

      // after creating a new Todo, close the form
      Navigator.of(context).pop();
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
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