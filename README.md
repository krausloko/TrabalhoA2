# Trabalho A2 - econhecimento de caracteres em placas de identificação de veículos

Segundo Trabalho da disciplina BLU3040 - Visao Computacional em Robótica, UFSC - Campus Blumenau

## Function:
A desevolvida função recebe uma imagem com a placa de um veículo e retorna os caracteres alfanuméricos.

## Quick start:
<p>1- Fazer download completo do repositório.<p>
<p>2- Adicionar a função 'Reconhecer.m' e as imagens na pasta do Matlab.<p>
<p>3- Executar a função 'Reconhecer.m' passando como parâmetro a imagem da placa.<p>
<p>4- Observar na Command Window os caracteres identificados.<p>

## How it works:
**Parte 1: Carregar/Tratar as Imagens**  
A imagem da placa é carrega, o treshold é calculado e é aplicada uma máscara na imagem.  
**Parte 2: Calcular Dimensões da Placa**  
Calcular as a relação do comprimento com a altura para verificar qual o tipo de placa (carro/caminhão ou moto).  
**Parte 3: Encontrar BLOBS**  
Função 'iblob' do Matlab é aplicada na imagem com a máscara.  
**Parte 4: Selecionar BLOBS**  
Etapas de verificação para selecionar apenas blobs referentes ao caracteres.  
**Parte 5: Organizar BLOBS**  
Dispor blobs de acordo com a organização da placa.  
**Parte 6: Criar imagem do BLOBS**  
 A partir da localização dos blobs são criadas imagens dos caracteres.  
**Parte 7: Carregar Modelos**  
 Carregar os modelos correspondentes a cada uma das letras e dos números.  
**Parte 8: Identificar BLOBS**  
 Com a imagem dos caracteres e os modelos a função de similaridade ZNCC faz uma comparação e encontra qual é o caractere.  
**Parte 9: Montar Placa**  
 Com os caracteres é criado um vetor de caracteres da placa.  
 
Para ver o embasamento teórico e explicação detalhada do código basta ler o arquivo 'Relatório A2 - Visão Computacional.pdf'



## Results:
**Placa**  
![placagit1](https://user-images.githubusercontent.com/35512686/40154965-a1e3be34-5967-11e8-8e91-1cbf69175b18.png)
 **Placa com Máscara**  
![placagit2](https://user-images.githubusercontent.com/35512686/40154966-a20e5324-5967-11e8-9d52-14dfa4f0ed1c.png)
 **Blobs Selecionados**    
 - Blobs Letras:  
![placagit3](https://user-images.githubusercontent.com/35512686/40154968-a2390826-5967-11e8-987e-3676b8f1e2a4.png)
 - Blobs Números:  
![placagit4](https://user-images.githubusercontent.com/35512686/40154969-a2657122-5967-11e8-9d27-fd07f9cd9644.png)
 - Blobs Estado:  
![placagit5](https://user-images.githubusercontent.com/35512686/40155083-237f0476-5968-11e8-9cac-97faa0e40040.png)
 - Blobs Cidade:  
![placagit6](https://user-images.githubusercontent.com/35512686/40155084-23a9b392-5968-11e8-8f5b-f7a2d7a1a93f.png)
**Caracteres Identificados**    
 Letras e Números:  
 "ABC1234"  
 Estado e Cidade:  
 "PR-CURITIBA  
## Requirements:
- Matlab R2016 ou mais recente
- Machine Vision Toolbox - Peter Corke
## License:
This toolbox is under the MIT License: http://opensource.org/licenses/MIT.
