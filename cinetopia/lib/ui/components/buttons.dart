import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final IconData? icon; // Ícone opcional (pode ser nulo)
  final Function onTap;

  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Ink(
        // InkWell cria uma área clicável
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 19),
        decoration: BoxDecoration(
          color: Color(0xFFB370FF),
          borderRadius: BorderRadius.circular(50),
        ), 
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centraliza o conteúdo horizontalmente
          mainAxisSize:
              MainAxisSize.min, // Ajusta o tamanho do botão ao conteúdo
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                color: Color(0XFF1D0E44),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            icon != null ? Icon(icon, color: Color(0XFF1D0E44)) : Container(),
          ],
        ),
      ),
    );
  }
}
