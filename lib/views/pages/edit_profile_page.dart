import 'package:e_commerc_app/utils/app_color.dart';
import 'package:e_commerc_app/views/widgets/label_with_textfield_widget.dart';
import 'package:e_commerc_app/views/widgets/social_media_bottom.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),

          actions: [
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.black,
                size: 32, // كبر الحجم هنا من 24/28 الافتراضي
              ),
              onSelected: (value) {
                if (value == 'logout') {
                  // اعمل logout أو أي حاجة
                } else if (value == 'settings') {
                  // افتح صفحة settings
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/my.jpg'),
                      radius: 50,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ahmed Bahaa',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Ahmed Bahaa@gmail.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelWithTextField(
                        label: 'Username',
                        controller: _userNameController,
                        prefixIcon: Icons.person,
                        hintText: 'Ahmed Bahaa',
                        obsecureText: false,
                      ),
                      const SizedBox(height: 20),
                      LabelWithTextField(
                        label: 'Email',
                        controller: _emailController,
                        prefixIcon: Icons.email,

                        obsecureText: false,
                        hintText: 'Ahmed Bahaa@gmail.com',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Account Link With   ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SocialMediaBottom(
                    imgurl:
                        'https://t4.ftcdn.net/jpg/03/91/79/25/360_F_391792593_BYfEk8FhvfNvXC5ERCw166qRFb8mYWya.jpg',
                    text: 'Google',
                    isLoading: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // اعمل حفظ البيانات

                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
