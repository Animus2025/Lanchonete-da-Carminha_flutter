// Importa os widgets do Flutter
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

// Componente visual reutilizável para exibir um card de produto
class ProdutoCardBase extends StatelessWidget {
  // Nome do produto
  final String nome;

  // Caminho da imagem do produto (deve estar no assets)
  final String imagem;

  // Preço total do produto (considerando quantidade, se for o caso)
  final double precoTotal;

  // Widget externo que exibe controle de quantidade (ex: botões + e -)
  final Widget quantidadeWidget;

  // Widget extra opcional (ex: descrição, categoria, ingredientes...)
  final Widget? extraWidget;

  // Callback que será chamado ao clicar no botão "ADICIONAR"
  final VoidCallback onAdicionar;

  // Construtor da classe
  const ProdutoCardBase({
    super.key,
    required this.nome,
    required this.imagem,
    required this.precoTotal,
    required this.quantidadeWidget,
    this.extraWidget,
    required this.onAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ), // Espaço externo
      padding: const EdgeInsets.all(16), // Espaço interno
      decoration: BoxDecoration(
        color: AppColors.pretoClaro, // Fundo escuro com transparência
        borderRadius: BorderRadius.circular(12), // Cantos arredondados
        boxShadow: [
          // Sombra para dar um toque de profundidade
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os itens ao topo
            children: [
              // Coluna da esquerda: nome, extraWidget, quantidade
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinha tudo à esquerda
                  children: [
                    // Nome do produto com estilização especial
                    Text(
                      nome,
                      style: const TextStyle(
                        color: AppColors.branco, // Cor do texto
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Bebas Neue',
                      ),
                    ),
                    // Se houver um widget extra (ex: descrição), exibe ele
                    if (extraWidget != null) ...[
                      const SizedBox(height: 8), // Espaço antes do extra
                      extraWidget!,
                    ],
                    const SizedBox(
                      height: 8,
                    ), // Espaço antes do controle de quantidade
                    quantidadeWidget, // Widget externo com + e - ou outro controle
                  ],
                ),
              ),
              const SizedBox(width: 16), // Espaço entre o texto e a imagem
              // Imagem do produto à direita
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  8,
                ), // Arredondamento da imagem
                child: Image.asset(
                  imagem, // Caminho da imagem
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain, // Corta a imagem pra preencher o espaço
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Espaço antes da linha final
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Preço do produto com formatação e cor especial
              Text(
                'R\$${precoTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.laranja, // Dourado claro
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              // Botão para adicionar o produto ao carrinho
              ElevatedButton.icon(
                onPressed: onAdicionar, // Chama a função passada
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('ADICIONAR', style: TextStyle(fontSize: 25)),
                // Estilo do botão
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.laranja, // Cor do botão
                  foregroundColor: AppColors.preto, // Cor do texto e ícone
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
