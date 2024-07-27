import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF318c3c),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            onTap: () {
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language: EN'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('App Info'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact Us'),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}