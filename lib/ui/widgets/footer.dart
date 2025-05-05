import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Define a cor preta fixa para o rodapé
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0), // Espaçamento geral
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Linha com localização e ícones de redes sociais
          Row(
            children: [
              // Ícone de localização
              const Icon(
                Icons.location_on,
                color: Color(0xffF6C484),
                size: 28,
              ),
              const SizedBox(width: 8), // Espaçamento entre o ícone e o texto
              const Expanded(
                child: Text(
                  'Rua Antônio Moreira Barros N°10 Centro, Teixeiras, MG',
                  style: TextStyle(color: Color(0xffF6C484), fontSize: 12),
                ),
              ),
              const SizedBox(width: 25), // Espaçamento entre o texto e os ícones

              // Ícone do WhatsApp
              GestureDetector(
                onTap: () async {
                  final Uri whatsappUrl = Uri.parse("https://wa.me/5531971520049");
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  } else {
                    print("Não foi possível abrir o WhatsApp");
                  }
                },
                child: Image.asset(
                  'lib/assets/icons/whatsapp.png',
                  color: const Color(0xffF6C484),
                  width: 28,
                  height: 28,
                ),
              ),
              const SizedBox(width: 20), // Espaçamento entre os ícones

              // Ícone do Instagram
              GestureDetector(
                onTap: () async {
                  final Uri instagramUrl =
                      Uri.parse("https://www.instagram.com/lanchonete_carminha");
                  if (await canLaunchUrl(instagramUrl)) {
                    await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
                  } else {
                    print("Não foi possível abrir o Instagram");
                  }
                },
                child: Image.asset(
                  'lib/assets/icons/instagram.png',
                  color: const Color(0xffF6C484),
                  width: 28,
                  height: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}