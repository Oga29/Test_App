import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oga/support/new_request_page.dart';
import 'package:test_oga/support/support_request_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportRequestPage extends StatelessWidget {
  const SupportRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<SupportRequestBloc>(context).add(FetchRequestsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<SupportRequestBloc, SupportRequestState>(
        builder: (context, state) {
          if (state is SupportRequestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SupportRequestLoaded) {
            final requests = state.requests;

            if (requests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/technical_support_illustration.svg'),
                    const SizedBox(height: 20),
                    const Text('No support requests found.'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<SupportRequestBloc>(context).add(FetchRequestsEvent());
              },
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    child: ListTile(
                      title: Text(request.message),
                      subtitle: Text('Created at: ${request.createdAt}'),
                      onTap: () {
                       
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('Error loading support requests'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewRequestPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () async {
            const whatsappUrl = 'whatsapp://send?text=Hello%20Support';
            // ignore: deprecated_member_use
            if (await canLaunch(whatsappUrl)) {
              // ignore: deprecated_member_use
              await launch(whatsappUrl);
            } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Could not open WhatsApp")),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/whatsapp_icon.svg', height: 24),
              const SizedBox(width: 10),
              const Text('WhatsApp Help Desk'),
            ],
          ),
        ),
      ],
    );
  }
}
