%%---------------------------------
% Copyright (C) 2017-2018, by Marcelo R. Petry
% This file is distributed under the MIT license
% 
% Copyright (C) 2017-2018, by Marcelo R. Petry
% Este arquivo � distribuido sob a licen�a MIT
%
% IdentificarPlaca(imagem)
% imagem - string com nome da imagem que contem a placa 
%%---------------------------------

%%---------------------------------
% BLU3040 - Visao Computacional em Robotica
% Avaliacao 2 - Deteccao de placas
% Requisitos:
%   MATLAB
%   Machine Vision Toolbox 
%       P.I. Corke, �Robotics, Vision & Control�, Springer 2011, ISBN 978-3-642-20143-1.
%       http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox
%%---------------------------------

%%---------------------------------
% Objetivo 
% O reconhecimento de caracteres em arquivos de imagens � uma tarefa
% extremamente �til dada a diversificada gama de aplica��es. O
% reconhecimento de placas veiculares, por exemplo, tem se demonstrado
% fundamental para o controle autom�tico de entrada e sa�da de ve�culos em
% portos, aeroportos, terminais ferrovi�rios, industrias e centros
% comerciais. Na rob�tica o reconhecimento de placas � empregado em rob�s
% de vigil�ncia e, mais recentemente, como ferramenta auxiliarem ve�culos
% aut�monos. 
%
% O objetivo deste trabalho consiste em desenvolver uma fun��o que receba
% imagens com placas de ve�culos e seja capaz de reconhecer e retornar os
% caracteres alfanum�ricos utilizando template matching e features de regi�o. 
%
%%---------------------------------

%%---------------------------------
% Dataset 
% O dataset padr�o para testes cont�m duas imagens coloridas, uma
% placa de automovel e uma placa de motocicleta, e esta disponivel na pasta /dataset/
%%---------------------------------


%%---------------------------------
% Entregas
% Cada grupo dever� descrever a sua funcao sob a forma de relat�rio t�cnico. 
% No relat�rio dever� ser apresentado:
% * Contextualiza��o
% * Breve explica��o sobre as metodologias utilizas
% * Descri��o da l�gica 
% * Testes e resultados
% * Conclus�o
% 
% Al�m do relat�rio, cada um dos grupos dever� criar um projeto p�blico no
% GitHub e fazer upload do c�digo desenvolvido. O link para o projeto do
% GitHub dever� constar no relat�rio entregue. O projeto no GitHub dever�
% conter um arquivo README explicando brevemente o algoritmo e como
% execut�-lo. Cada grupo tamb�m dever� realizar uma demonstra��o do seu
% algoritmo durante a aula.

%%---------------------------------
% Avalia��o 
% A pontuacao do trabalho ser� atribuida de acordo com os
% criterios estabaleceidos a seguir: 
% *At� 7.0: A funcao recebe como argumento uma imagem, e retorna um vetor com
% dois elementos contendo os tr�s caracteres alfabeticos e os quatro
% caracteres numericos referentes ao n�mero da placa do ve�culo. O
% algoritmo devera reconhecer os caracteres em pelo menos 3 imagens
% diferentes.
% *At� 8.0: Alem dos requesitos estabelecidos anteriormente, a funcao
% devera retornar os caracteres numericos referentes ao estado e a cidade.
% *At� 10.0: Alem dos requesitos estabelecidos anteriormente, as imagens
% passadas para a funcao deverao ter outros elementos alem da placa do
% veiculo, tais como parachoque, pavimento, pessoas, etc. Esta dever�
% primeiramente identificar, extrair e orientar a placa. Devem ser
% utilizadas tecnicas de conversao do espaco de cor, operacoes monadicas e
% homografia.
% *At� 12.0: Alem dos requesitos estabelecidos anteriormente, a funcao
% devera receber video, de arquivo ou da webcam, e retornar os
% caracteres da placa.
%%---------------------------------

%Desenvolva seu codigo aqui:

function IdentificarPlaca(imagem)

% Parte 1 - Carregar/Tratar Imagem
%Usuario inserir imagem
%Usuario inserior caminho para a pasta de imagens - neste caso dataset
disp('Aten��o: A imagem e o arquivo do matlab devem estar na mesma pasta')
disp('Aten��o: Limpar vari�veis')
%Carregar imagem
% f(182).umin-f(182).umax=-438
% f(182).vmin-f(182).vmax=-286
im=iread(imagem,'double');
%Passar para escala de cinza e inverter
im=rgb2gray(im);
%Mascara para trasnformar imagem
[v u]=size(im);
tam=[v u];
mascara=zeros(v,u);
% Primeira Op��o - treshold manual: tentativa e erro at�
% encontrar melhor valor, desvantagem de ser especifico para cada imagem.
% for i=1:v
%     for n=1:u
%     if(im(i,n)<0.3)
%         mascara(i,n)=1;
%     end
%     end
% end
% Segunda Op��o - treshhold autom�tico: fun��o que otimiza valor de escolha
% do treshold, vantagem de ser calculado para cada imagem.
 T=otsu(im)
 T=T*0.8;
for i=1:v
    for n=1:u
    if(im(i,n)<T)
      mascara(i,n)=1;
    end
    end
end

%Verificar que tipo de ve�culo: CARRO OU MOTO
proporcao=max(tam)/min(tam);
tam_carro=400/130;
tam_moto=20/17;

if(abs(proporcao-tam_carro)>abs(proporcao-tam_moto))
modelo=1;
disp('� uma placa de MOTO')
else
modelo=2;
disp('� uma placa de CARRO')
end

% f=iblobs(mascara,'greyscale');
% area_ordenada(1,:)=sort(f.area);
% teste=mascara(f(1).vmin:f(1).vmax,f(1).umin:f(1).umax);
% a=zeros(1,length(f));
% b=zeros(1,length(f));
% t=zeros(1,length(f));
% r=zeros(1,length(f));
% 
% for i=1:length(f)
%     a(1,i)=f(i).a;
%     b(1,i)=f(i).b;
%     t(1,i)=f(i).theta;
%     razao(1,i)=a(1,i)/b(1,i);
%     
% end
% 
% razao=sort(razao);
%% Parte 2 - Encontrar BLOBS e selecionar BLOBS v�lidos
%Fun��o IBLOB que retorna um vetor de features de regi�o que descrevem as
%regi�es conectadas na imagem.
f=iblobs(mascara,'greyscale');
%Cria um vetor com as �reas dos blobs em ordem(menor -> maior)
area_ordenada(1,:)=sort(f.area);

% A seguir est�o as verifica��es para descartar BLOBS que n�o correspondem
% aos caracteres da placa:
%BLOBS DAS LETRAS E NUMEROS
%La�o para encontrar qual BLOB corresponde a cada �rea (f(i).label!)
for i=1:length(f)
    for n=1:length(f)
   if(area_ordenada(1,i)==f(n).area)
       area_ordenada(2,i)=n;
   end
    end
end

%La�os para selecionar apenas �reas v�lidas
% Primeiro La�o - restri��o de tamanho: BLOBS com �reas pequenas e m�dia
% s�o descartados (valor definido manualmente)
cont=0;
for i=1:length(f)
    if(area_ordenada(1,i)>1e3)
    cont=cont+1;
    area_valida(1,cont)=area_ordenada(1,i);
    area_valida(2,cont)=area_ordenada(2,i);
    end
end

%CARROS
if(modelo==2)
% Segundo La�o - pela localiza��o: c�lculo do vmin m�dio e defini��o de uma
% dist�ncia m�xima
%Calcular Vmin medio
soma=0;
div=0;
for i=1:length(area_valida)
    soma=f(area_valida(2,i)).vmin+soma;
    div=div+1;
end
vminmed=soma/div;
cont=0;
% Testar se o BLOB est� a uma dist�ncia menor que 20 da Vmin m�dio �
% considerado v�lido, caso contr�rio � descartado
for i=1:length(area_valida)
    if(abs(f(area_valida(2,i)).vmin-vminmed)<20)
    cont=cont+1;
    area_valida11(1,cont)=area_valida(1,i);
    area_valida11(2,cont)=area_valida(2,i);
       end
end
% Terceiro La�o - pela altura: todas as tem aprodimamente o mesmo tamanho
soma=0;
div=0;
for i=1:length(area_valida11)
    soma=f(area_valida11(2,i)).vmax-f(area_valida11(2,i)).vmin+soma;
    div=div+1;
end
h_med=soma/div;
cont=0;
for i=1:length(area_valida11)
    if(f(area_valida11(2,i)).vmax-f(area_valida11(2,i)).vmin>(0.8*h_med) && f(area_valida11(2,i)).vmax-f(area_valida11(2,i)).vmin<(1.2*h_med))
    cont=cont+1;
    area_valida13(1,cont)=area_valida11(1,i);
    area_valida13(2,cont)=area_valida11(2,i);
     end
end

%La�o para colocar �reas na mesma ordem da placa
%umin bounding box, minimum horizontal coordinate 
%umax bounding box, maximum horizontal coordinate
for i=1:length(area_valida13)-1
   
for n=i:length(area_valida13)-1
   if(f(area_valida13(2,i)).umin>f(area_valida13(2,n+1)).umin)
       
    aux1=area_valida13(1,i);
    aux2=area_valida13(2,i);
    
    area_valida13(1,i)=area_valida13(1,n+1);
    area_valida13(2,i)=area_valida13(2,n+1);
    
    area_valida13(1,n+1)=aux1;
    area_valida13(2,n+1)=aux2; 
   end 
end
end
end

%MOTOS
if(modelo==1)
%La�os para colocar �reas na mesma ordem da placa
%Para moto ser�o utilizados dois la�os - um para separar numeros e letras
%outro para colocar letras e numeros na ordem
%La�o 1 - ordenar pela altura - tr�s menos umin s�o referentes as letras
%os quatros maiores umin s�o referentes aos numeros
for i=1:length(area_valida)-1
for n=i:length(area_valida)-1
   if(f(area_valida(2,i)).vmin>f(area_valida(2,n+1)).vmin)
       
    aux1=area_valida(1,i);
    aux2=area_valida(2,i);
    
    area_valida(1,i)=area_valida(1,n+1);
    area_valida(2,i)=area_valida(2,n+1);
    
    area_valida(1,n+1)=aux1;
    area_valida(2,n+1)=aux2; 
    
   end 
end
end

%La�o 2 - depois de separar numeros e letras basta colocar na ordem (esquerda-direita)
for i=1:2
   
for n=i:2
   if(f(area_valida(2,i)).umin>f(area_valida(2,n+1)).umin)
       
    aux1=area_valida(1,i);
    aux2=area_valida(2,i);
    
    area_valida(1,i)=area_valida(1,n+1);
    area_valida(2,i)=area_valida(2,n+1);
    
    area_valida(1,n+1)=aux1;
    area_valida(2,n+1)=aux2; 
    
   end 
end
end

for i=4:6
   
for n=i:6
   if(f(area_valida(2,i)).umin>f(area_valida(2,n+1)).umin)
       
    aux1=area_valida(1,i);
    aux2=area_valida(2,i);
    
    area_valida(1,i)=area_valida(1,n+1);
    area_valida(2,i)=area_valida(2,n+1);
    
    area_valida(1,n+1)=aux1;
    area_valida(2,n+1)=aux2; 
    
   end 
end
end

area_valida13(1,:)=area_valida(1,:);
area_valida13(2,:)=area_valida(2,:);
end

%BLOBS DA CIDADE - Mesma l�gica para os dois tipos de placa
%Usar apenas parte superior - n�o considerar demais BLOBS
im2=mascara(45:f(area_valida(2,i)).vmin-10,:);
f2=iblobs(im2,'greyscale');
area_ordenada2(1,:)=sort(f2.area);
f2_D=f2.area;
%La�o 1 - Link entre area e a label
for i=1:length(f2_D)
    for n=1:length(f2_D)
   if(area_ordenada2(1,i)==f2_D(n))
       area_ordenada2(2,i)=n;
       f2_D(n)=-n;
       break;
   end
    end
end

%La�os para selecionar apenas �reas v�lidas
% Primeiro La�o - restri��o de tamanho
cont=0;
for i=1:length(f2)
    if(area_ordenada2(1,i)>=20)
    cont=cont+1;
    area_valida2(1,cont)=area_ordenada2(1,i);
    area_valida2(2,cont)=area_ordenada2(2,i);
    end   
end
% Segundo La�o - pela localiza��o: c�lculo do vmin m�dio e defini��o de uma
% dist�ncia m�xima
%Calcular Vmin medio

soma=0;
div=0;
for i=1:length(area_valida2)
    soma=f2(area_valida2(2,i)).vmin+soma;
    div=div+1;
end
vminmed=soma/div;
cont=0;

for i=1:length(area_valida2)
    if(abs(f2(area_valida2(2,i)).vmin-vminmed)<vminmed*1.2)
    cont=cont+1;
    area_valida21(1,cont)=area_valida2(1,i);
    area_valida21(2,cont)=area_valida2(2,i);
       end
end
% Terceiro La�o - pela altura: todas as tem aprodimamente o mesmo tamanho
soma=0;
div=0;
for i=1:length(area_valida21)
    soma=f2(area_valida21(2,i)).vmax-f2(area_valida21(2,i)).vmin+soma;
    div=div+1;
end

h_med=soma/div;
cont=0;
%CUIDADO COM ACENTUA��O !!!!!!!!!!!!
for i=1:length(area_valida21)
    if(f2(area_valida21(2,i)).vmax-f2(area_valida21(2,i)).vmin>18 && f2(area_valida21(2,i)).vmax-f2(area_valida21(2,i)).vmin<30)
    cont=cont+1;
    area_valida23(1,cont)=area_valida21(1,i);
    area_valida23(2,cont)=area_valida21(2,i);
     end
end

%La�o para colocar �reas na mesma ordem da placa
for i=1:length(area_valida23)-1
   
for n=i:length(area_valida23)-1
   if(f2(area_valida23(2,i)).umin>f2(area_valida23(2,n+1)).umin)
       
    aux1=area_valida23(1,i);
    aux2=area_valida23(2,i);
    
    area_valida23(1,i)=area_valida23(1,n+1);
    area_valida23(2,i)=area_valida23(2,n+1);
    
    area_valida23(1,n+1)=aux1;
    area_valida23(2,n+1)=aux2; 
   end 
end
end

% Quarto La�o - verifica��o pela distancia do blob anterior e posterior ||
cont=0;
for n=1:length(area_valida23) 
 if(n==1)
    if(abs(f2(area_valida23(2,n)).umin-f2(area_valida23(2,n+1)).umin)<30)
    cont=cont+1;
    area_valida5(1,cont)=area_valida23(1,n);
    area_valida5(2,cont)=area_valida23(2,n);
    end 
 end 
   
   if(n>1 && n~=length(area_valida23))
    if(abs(f2(area_valida23(2,n)).umin-f2(area_valida23(2,n+1)).umin)<30 || abs(f2(area_valida23(2,n)).umin-f2(area_valida23(2,n-1)).umin)<30)
    cont=cont+1;
    area_valida5(1,cont)=area_valida23(1,n);
    area_valida5(2,cont)=area_valida23(2,n);
    end 
   end 
   
   if(n==length(area_valida23))
    if(abs(f2(area_valida23(2,n)).umin-f2(area_valida23(2,n-1)).umin)<30)
    cont=cont+1;
    area_valida5(1,cont)=area_valida23(1,n);
    area_valida5(2,cont)=area_valida23(2,n);
    end 
 end 
end
%% Parte 3 - Armazenar letras,n�meros,cidade

% Numeros e letras
for i=1:length(area_valida13)
if(i<4)    
letra{i}=mascara(f(area_valida13(2,i)).vmin:f(area_valida13(2,i)).vmax,f(area_valida13(2,i)).umin:f(area_valida13(2,i)).umax);
end

%ignora area_valida(4) pois � o tra�o (hifen) que n�o � interessante para a
%identifica��o das placas
if(i>=4) 
numero{i-3}=mascara(f(area_valida13(2,i)).vmin:f(area_valida13(2,i)).vmax,f(area_valida13(2,i)).umin:f(area_valida13(2,i)).umax);
end
end

%Cidade e estado
for i=1:length(area_valida5)
if(i<3)    
estado{i}=im2(f2(area_valida5(2,i)).vmin:f2(area_valida5(2,i)).vmax,f2(area_valida5(2,i)).umin:f2(area_valida5(2,i)).umax);
end

if(i>=3) 
    if(abs(f2(area_valida5(2,i)).vmax-f2(area_valida21(2,i)).vmin)>40)
     entou=1+entou;
     cidade{i-2}=im2((f2(area_valida5(2,i)).vmin):f2(area_valida5(2,i)).vmax,f2(area_valida5(2,i)).umin:f2(area_valida5(2,i)).umax);
    else
    cidade{i-2}=im2(f2(area_valida5(2,i)).vmin:f2(area_valida5(2,i)).vmax,f2(area_valida5(2,i)).umin:f2(area_valida5(2,i)).umax);
    end   
end
end

figure
for i=1:length(letra)
   idisp(letra) ;
end
figure
for i=1:length(numero)
   idisp(numero) ;
end
figure
for i=1:length(estado)
   idisp(estado) ;
end
figure
for i=1:length(cidade)
   idisp(cidade) ;
end
%% %% Parte 4 - Carregar os TEMPLATES
%v=124
%u=75
%Letras
%[ui vi]=size(alfabeto{2,2});

alfabeto{1,1}='I';
alfabeto{2,1}=1-rgb2gray(iread('I10.jpg','double'));

alfabeto{1,2}='B';
alfabeto{2,2}=1-rgb2gray(iread('B.jpg','double'));

alfabeto{1,3}='C';
alfabeto{2,3}=1-rgb2gray(iread('CC.jpg','double'));

alfabeto{1,4}='D';
alfabeto{2,4}=1-rgb2gray(iread('D2.jpg','double'));

alfabeto{1,5}='E';
alfabeto{2,5}=1-rgb2gray(iread('E.jpg','double'));

alfabeto{1,6}='F';
alfabeto{2,6}=1-rgb2gray(iread('F.jpg','double'));%19

alfabeto{1,7}='G';
alfabeto{2,7}=1-rgb2gray(iread('G.jpg','double'));%modelo certo

alfabeto{1,8}='H';
alfabeto{2,8}=1-rgb2gray(iread('H.jpg','double'));

alfabeto{1,9}='A';
alfabeto{2,9}=1-rgb2gray(iread('Aa.jpg','double'));

alfabeto{1,10}='J';
alfabeto{2,10}=1-rgb2gray(iread('J.jpg','double'));

alfabeto{1,11}='K';
alfabeto{2,11}=1-rgb2gray(iread('K.jpg','double'));

alfabeto{1,12}='L';
alfabeto{2,12}=1-rgb2gray(iread('L.jpg','double'));

alfabeto{1,13}='M';
alfabeto{2,13}=1-rgb2gray(iread('M.jpg','double'));

alfabeto{1,14}='N';
alfabeto{2,14}=1-rgb2gray(iread('N.jpg','double'));

alfabeto{1,15}='O';
alfabeto{2,15}=1-rgb2gray(iread('O.jpg','double'));

alfabeto{1,16}='P';
alfabeto{2,16}=1-rgb2gray(iread('P.jpg','double'));

alfabeto{1,17}='Q';
alfabeto{2,17}=1-rgb2gray(iread('Q.jpg','double'));

alfabeto{1,18}='R';
alfabeto{2,18}=1-rgb2gray(iread('R.jpg','double'));

alfabeto{1,19}='S';
alfabeto{2,19}=1-rgb2gray(iread('S.jpg','double'));

alfabeto{1,20}='T';
alfabeto{2,20}=1-rgb2gray(iread('T.jpg','double'));

alfabeto{1,21}='U';
alfabeto{2,21}=1-rgb2gray(iread('U.jpg','double'));

alfabeto{1,22}='V';
alfabeto{2,22}=1-rgb2gray(iread('V.jpg','double'));

alfabeto{1,23}='W';
alfabeto{2,23}=1-rgb2gray(iread('w.jpg','double'));

alfabeto{1,24}='X';
alfabeto{2,24}=1-rgb2gray(iread('X.jpg','double'));

alfabeto{1,25}='Y';
alfabeto{2,25}=1-rgb2gray(iread('y.jpg','double'));

alfabeto{1,26}='Z';
alfabeto{2,26}=1-rgb2gray(iread('Z.jpg','double'));

numerico{1,1}='1';
numerico{2,1}=1-rgb2gray(iread('I.jpg','double'));

numerico{1,2}='2';
numerico{2,2}=1-rgb2gray(iread('2.jpg','double'));

numerico{1,3}='3';
numerico{2,3}=1-rgb2gray(iread('3.jpg','double'));

numerico{1,4}='4';
numerico{2,4}=1-rgb2gray(iread('44.jpg','double'));

numerico{1,5}='5';
numerico{2,5}=1-rgb2gray(iread('5.jpg','double'));

numerico{1,6}='6';
numerico{2,6}=1-rgb2gray(iread('66.jpg','double'));

numerico{1,7}='7';
numerico{2,7}=1-rgb2gray(iread('77.jpg','double'));

numerico{1,8}='8';
numerico{2,8}=1-rgb2gray(iread('8.jpg','double'));

numerico{1,9}='9';
numerico{2,9}=1-rgb2gray(iread('9.jpg','double'));

numerico{1,10}='0';
numerico{2,10}=1-rgb2gray(iread('0.jpg','double'));
 
% 
% for i=1:length(alfabeto)
%         %Passar para escala de cinza e inverter
% it=alfabeto{2,i};
% %Mascara para trasnformar imagem
% [vt ut]=size(it);
% tam=[vt ut];
% mascarat=zeros(vt,ut);
% 
%  T=otsu(it)
% for q=1:vt
%     for w=1:ut
%     if(it(q,w)<T)
%       mascarat(q,w)=1;
%     end
%     end
% end
%    alfabeto{2,i}=1-mascarat;  
%    alfabeto{2,i}=logical(alfabeto{2,i})
%    clear it
%    clear mascarat 
% end
%% Parte 5 -  Template matching: comparar n�meros e letras encontradas com os templates

%The zncc similarity measure is invariant to affine changes in image intensity (brightness offset and scale).
%Letras
% Identifica��o LETRAS E N�MEROS
con=0;
match=-1e6;
cont=0;
for n=1:3
for i=1:length(alfabeto) 
  template=isamesize(letra{n},alfabeto{2,i});
  [l c]=size(template);
 TF=isnan(template);
 conta=0;
   for k=1:l
    for p=1:c
    if(TF(k,p)==1)
    template(k,p)=0;  
    conta=conta+1;
    end
    end
   end

   m=zncc(template,alfabeto{2,i});
    cont=cont+1;
   mvet{cont}=m;
   if(m>match)
   con=con+1;     
   placa{n}=alfabeto{1,i};
   match=m;
   m2vet{n}=m;
   end
end
match=-1e6;
end

%Numeros
match=-1e6;
cont=0;
for n=1:4
    %numerico nao foi todo criado arrumar i
for i=1:length(numerico) 
   template=isamesize(numerico{2,i},numero{n});
   
    [l c]=size(template);
 TF=isnan(template);
 conta=0;
   for k=1:l
    for p=1:c
    if(TF(k,p)==1)
    template(k,p)=0;  
    conta=conta+1;
    end
    end
   end
   m=zncc(template,numero{n});
      cont=cont+1;
   mvet2{cont}=m
   if(m>=match)
   placa{n+3}=numerico{1,i};
   match=m;
   m2vet2{n}=m;
   end
end
match=-1e6;
end

placa_letras=strcat(placa{1},placa{2},placa{3});
placa_numeros=strcat(placa{4},placa{5},placa{6},placa{7});
placa_final=[placa_letras,placa_numeros]


%% Identifica��o CIDADE
%Sigla ESTADO
match=-1e6;
for n=1:(length(estado))
    %numerico nao foi todo criado arrumar i
for i=1:length(alfabeto) 
   
   [linha coluna]=size(estado{n});
   compara=zeros(round(linha/2),round(coluna/2));
   estado2=isamesize(estado{n},compara);  
   template=isamesize(alfabeto{2,i},compara); 
   m=zncc(template,estado2);
   %template=isamesize(estado{n},alfabeto{2,i});   
   %m=zncc(template,alfabeto{2,i});
   if(m>match)
   placa_estado{n}=alfabeto{1,i};
   match=m;
   end
end
match=-1e6;
end

%Nome CIDADE
match=-1e6;
for n=1:(length(cidade))
    %numerico nao foi todo criado arrumar i
for i=1:length(alfabeto) 
   clear template cidade2 compara template2

   [linha coluna]=size(cidade{n});
   compara=zeros(round(linha/2),round(coluna/2));
   cidade2=isamesize(cidade{n},compara);  
   template=isamesize(alfabeto{2,i},compara);
   
   if(i~=1)
   [linha coluna]=size(cidade2);
   linha20=round(linha*0.05);
   coluna20=round(coluna*0.05);
   cidade20=ones(linha,coluna);
   
   for p=1:linha20
   cidade20(p,:)=0;
   end
   for p=linha:-1:(linha-linha20)+1
   cidade20(p,:)=0;
   end
   for p=1:coluna20
   cidade20(:,p)=0;
   end
   for p=coluna:-1:(coluna-coluna20)+1
   cidade20(:,p)=0;
   end
   cidade2=cidade20.*cidade2;
   template2=cidade20.*template;
   
   m=zncc(template2,cidade2);
   if(m>match)
   placa_cidade{n}=alfabeto{1,i};
   match=m;
   end 
   end
   
   if(i==1)  
   [linha coluna]=size(cidade2);
   linha20=round(linha*0.2);
   coluna20=round(coluna*0.2);
   cidade20=ones(linha,coluna);
   for p=1:linha20
   cidade20(p,:)=0;
   end
   for p=linha:-1:(linha-linha20)+1
   cidade20(p,:)=0;
   end
   for p=1:coluna20
   cidade20(:,p)=0;
   end
   for p=coluna:-1:(coluna-coluna20)+1
   cidade20(:,p)=0;
   end
   cidade2=cidade20.*cidade2;
   template2=cidade20.*template;
   
   m=zncc(template2,cidade2);
   maior=max(area_valida5(1,:))/2
   if(m>match && area_valida5(1,n+2)<maior)
   placa_cidade{n}=alfabeto{1,i};
   match=m;
   end 
   end    
    
end
   
match=-1e6;
end

placa_estado=strcat(placa_estado{:});
placa_cidade=strcat(placa_cidade{:});
placa_final2=[placa_estado,'-',placa_cidade];

disp('Caracteres Alfanum�ricos de Identifica��o:')
disp(placa_final)
disp('Caracteres Estado-Cidade:')
disp(placa_final2)
end
