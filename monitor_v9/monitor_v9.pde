import processing.pdf.*;

// Importações
import processing.serial.*;

Interface interfaceGrafica;
ColetorSerial coletor;

void setup() {
  size(1400, 960); //Definição do tamanho da tela
  interfaceGrafica = new Interface(); //Cria o objeto de inteface grafica (parte visual)
  coletor = new ColetorSerial(this, interfaceGrafica); //Cria o objeto que recebe os dados do arduino (comunicação serial)

}

void draw() { //o draw é a função rodando continuamente.
  background(255); //Limpa a bela com branco a cada frame
  interfaceGrafica.desenharFundo(); //Desenha o texto, botões, moldura
  if (interfaceGrafica.coletando) {
     interfaceGrafica.dadoEstatistico();
     interfaceGrafica.dadoEstatistico1();     
     interfaceGrafica.desenharGraficos(); //Condição de mostrar os graficos se o botção de coleta estiver ativo

  }
}

void mousePressed() {
  interfaceGrafica.tratarClique(mouseX, mouseY);
}

void mouseMoved() {
  redraw();
}

void serialEvent(Serial p) {
  coletor.receberDados(p);
}

// Classe responsável por controlar todos os elementos da tela: botões, fráficos, texto
class Interface {
  PFont f, fonteTitulo, frotulos, fonteeixo; //fonte e imagem
  PImage imgLogo;
  PImage imgpause;
  PImage imgstart;
  PImage iconepausa;
  PImage imgpolar;
  PImage imgPausa;
  PImage imgSeno;
  PImage imgZ;
  PImage imgRet;
  Grafico grafico1, grafico2, grafico3, grafico4, grafico5, grafico6; //Objetos da classe Grafico
  Estatistica estatistica; Estatistica estatistica1;//atributo da class
  Botao botaoIniciar, botaoParar, botaoImpedancia, botaoSinais, botaoRet, botaoPol; //Objetos da classe Botão
  boolean coletando = false; //Indica se a coleta de dados está ativa
  int abaAtual = 2; //Impedancia, 1 = Sinais Medidos
  int tsEstatistico = 0;
  int tsEstatistico1 = 0;
  int intEstatistico = 2000;
  float media = 0;
  float desvio = 0;
  float variancia = 0;
  float maximo = 0;
  float minimo = 0;
  float Max_valor = 0;
  float Min_valor = 0;
  float valorpp = 0;
  float Vpp = 0;
  float media1 = 0;
  float desvio1 = 0;
  float variancia1 = 0;
  float maximo1 = 0;
  float minimo1 = 0;
  float Max_valor1 = 0;
  float Min_valor1 = 0;
  float valorpp1 = 0;
  float Vpp1 = 0;
  boolean impedanciaPressionado = false;
  boolean iniciarPressionado = false;
  boolean retPressionado = false;
  boolean polPressionado = false;
  boolean sinalPressionado = false;
  boolean pararPressionado = false;
  color linhaverde = color(0, 255, 0);
  color linhaazul = color(100, 116, 230);
  int altbotao = 95;
  int larbotao = 160;
  
  

  Interface() { //Construtor: Objetos criados e personalizados
    f = createFont("Arial", 55);
    frotulos = createFont("Arial", 35);
    fonteTitulo = createFont("Arial", 20);
    fonteeixo = createFont("Arial", 15);
    imgLogo = loadImage("Logo.png");
    imgstart = loadImage("start.png");
    imgPausa = loadImage("Pausa.png");
    imgSeno = loadImage("Seno.png");
    imgpolar = loadImage("imgpolar.png");
    imgZ = loadImage("imgZ.png");
    imgRet = loadImage("imgRet.png");
    imgLogo.resize(150, 0);
    imgstart.resize(110, 0);
    imgPausa.resize(70, 0);
    imgSeno.resize(130,0);
    imgpolar.resize(400,0);
    imgZ.resize(350,0);
    imgRet.resize(350,0);
    
    grafico1 = new Grafico(195, 165, color(linhaverde), "Modo Polar - Amplitude");
    grafico2 = new Grafico(195, 550, color(linhaazul), "Modo Polar - Fase");
    grafico3 = new Grafico(195, 165, color(linhaverde), "Sinais Medidos - Tensão");
    grafico4 = new Grafico(195, 550, color(linhaazul), "Sinais Medidos - Corrente");
    grafico5 = new Grafico(195, 165, color(linhaverde), "Modo Retangular - Real");
    grafico6 = new Grafico(195, 550, color(linhaazul), "Modo Retangular - Imaginário");

    estatistica = new Estatistica();
    botaoIniciar = new Botao(15, 755, larbotao, altbotao, "Iniciar", color(20, 180, 70), color(20, 180, 70));
    botaoParar = new Botao(15, 850, larbotao, altbotao, "Parar", color(120), color(200, 70, 70));
    botaoSinais = new Botao(15, 228, larbotao, altbotao, "Tensão/Corrente", color(120), color(20, 180, 70));
    botaoImpedancia = new Botao(15, 323, larbotao, altbotao, "Impedância", color(20, 180, 70), color(20, 180, 70));
    botaoPol = new Botao(15, 486, larbotao, altbotao, "Polar", color(120), color(120));
    botaoRet = new Botao(15, 581, larbotao, altbotao, "Retangular", color(20, 180, 70), color(20, 180, 70));    
  
  }
  

  void desenharFundo() { //Método. Desenha a estrutura visual da inteface
    textFont(f);
    fill(13, 98, 58);
    text("Interface gráfica de monitoramento\n para medidor de bioimpedância", 260, 80);
    image(imgLogo, 30, 10);
 

    textFont(fonteTitulo);
    fill(255);
    textAlign(CENTER, TOP);
  
    //Retangulos para o painel central e o lateral esquerdo
    fill(60);
    rect(190, 150, 1200, 800, 5);
    fill(60);
    rect(10, 150, 170, 800, 5);
    fill(255);
    rect(15, 165, 160, 253, 5);
    rect(15, 423, 160, 253, 5);
    rect(15, 681, 160, 253, 5);
    
        
    textFont(frotulos);
    fill(13, 98, 58);
    textAlign(CENTER, TOP);
    text("Sinais", 15 + 160/2, 165 + 22);
    text("Modo", 15 + 160/2, 423 + 22);
    text("Coleta", 15 + 160/2, 681 + 25);

    
    textFont(fonteTitulo);
    
    estatistica.desenhar(media, desvio, variancia, maximo, minimo, Vpp, media1, desvio1, variancia1, maximo1, minimo1, Vpp1);
    botaoIniciar.desenhar();
    botaoParar.desenhar();
    botaoImpedancia.desenhar();
    botaoSinais.desenhar();
    botaoRet.desenhar();
    botaoPol.desenhar();
    tint(245);
    image(imgstart, 58, 702);
    noTint();
    tint(250);
    image(imgPausa, 60, 828);
    noTint();
    tint(254);
    image(imgSeno, 30, 155);
    noTint();
    tint(255);
    image(imgpolar, -95, 198);
    noTint();
    tint(255);
    image(imgZ, -60, 60);
    noTint();
    tint(255);
    image(imgRet, -60, 320);
    noTint();
    
    if (polPressionado){
      grafico1.desenharFundo_Ampli(); //Modo Polar - Amplitude
      grafico2.desenharFundo_fase(); //Modo Polar - Fase
    }
    
    if (retPressionado){
      grafico5.desenharFundo_Real(); //  Modo Retangular - Real
      grafico6.desenharFundo_Ima(); //  Modo Retangular - Imaginário
      
    }
    
    if (sinalPressionado){
      grafico3.desenharFundo();// Sinais Medidos - Tensão
      grafico4.desenharFundoA(); // Sinais Medidos - Corrente
    }
        
    textAlign(LEFT, CENTER);
    textSize(18);
  
  }

  void desenharGraficos() {
    if(iniciarPressionado & retPressionado & impedanciaPressionado ){
      grafico5.desenharDados(); //Real
      grafico6.desenharDados5(); //Imaginário       
    }
    if(iniciarPressionado & polPressionado & impedanciaPressionado){
      grafico1.desenharDados4(); //Amplitude
      grafico2.desenharDados5(); //Fase       
    }
    
   if(iniciarPressionado & sinalPressionado ){
      grafico3.desenharDados2(); //Seno
      grafico4.desenharDados3(); //Seno       
    }
 }

  //Verifica se algum botão foi clicado.
  void tratarClique(int x, int y) {
    if (botaoIniciar.estaSobre(x, y)) {
      iniciarPressionado = true;
      pararPressionado = false;
      
    }
    
    if (botaoRet.estaSobre(x, y)) {
      retPressionado = true;
      polPressionado = false;
    }

    if (botaoPol.estaSobre(x, y)) {
      polPressionado = true;
      retPressionado = false;
    }
    
    if (botaoSinais.estaSobre(x, y)) {
      sinalPressionado = true;
      polPressionado = false;
      retPressionado = false;
    }
    
    if (botaoImpedancia.estaSobre(x, y)){
      impedanciaPressionado = true;
      sinalPressionado = false;
    }
    
    // Iniciar coleta apenas se "Iniciar" e pelo menos um dos outros dois estiverem pressionados
    if (iniciarPressionado && (retPressionado || polPressionado || sinalPressionado)) {
      coletando = true;
      println("Coleta iniciada");
  }

    if (botaoParar.estaSobre(x, y)) {
      coletando = false;
      iniciarPressionado = false;
      retPressionado = false;
      polPressionado = false;
      sinalPressionado = false;
      println("Coleta parada");
  }

  redraw();
  

}


 void dadoEstatistico() {
   if (millis() - tsEstatistico > intEstatistico && coletor.dadosY.size() >= 100) {  //millis retorna o tempo atual desde que o código iniciou
     ArrayList<Float> ultimos = new ArrayList<Float>();
     for (int i = coletor.dadosY.size() - 100; i < coletor.dadosY.size(); i++) {
        ultimos.add(coletor.dadosY.get(i));
      }
      
      float soma = 0;
      float max = -Float.MAX_VALUE;
      float min = Float.MAX_VALUE;
      
      
      for (float v : ultimos) {
        soma += v;
        if (v > max) max = v;
        if (v < min) min = v;
      }
      
      float valorpp = abs(max) + abs(min);
      float mediaLocal = soma / ultimos.size();
      float somaQuadrado = 0;
      for (float v : ultimos) {
        somaQuadrado += sq(v - mediaLocal);
      }
      media = mediaLocal;
      variancia = somaQuadrado / ultimos.size();
      desvio = sqrt(variancia);
      maximo = max;
      minimo = min;
      Vpp = valorpp;
      
      tsEstatistico = millis();
      }
   }
   
    void dadoEstatistico1() {
   if (millis() - tsEstatistico1 > intEstatistico && coletor.dadosY1.size() >= 100) {  //millis retorna o tempo atual desde que o código iniciou
     ArrayList<Float> ultimos1 = new ArrayList<Float>();
     for (int i = coletor.dadosY1.size() - 100; i < coletor.dadosY1.size(); i++) {
        ultimos1.add(coletor.dadosY1.get(i));
      }
      
      float soma1 = 0;
      float max1 = -Float.MAX_VALUE;
      float min1 = Float.MAX_VALUE;
      
      
      for (float v : ultimos1) {
        soma1 += v;
        if (v > max1) max1 = v;
        if (v < min1) min1 = v;
      }
      
      float valorpp1 = abs(max1) + abs(min1);
      float mediaLocal1 = soma1 / ultimos1.size();
      float somaQuadrado1 = 0;
      for (float v : ultimos1) {
        somaQuadrado1 += sq(v - mediaLocal1);
      }
      media1 = mediaLocal1;
      variancia1 = somaQuadrado1 / ultimos1.size();
      desvio1 = sqrt(variancia);
      maximo1 = max1;
      minimo1 = min1;
      Vpp1 = valorpp1;
      
      tsEstatistico1 = millis();
      }
   }
   
}


// Classe para desenhar graficos
class Grafico {
  int x, y; //Atributo
  int corLinha; // Atributo
  String titulo; // Atributo
  int largura = 910, altura = 360; //Atributo
  

  Grafico(int x, int y, int corLinha, String titulo) {
    this.x = x;
    this.y = y;
    this.corLinha = corLinha;
    this.titulo = titulo;
  }
  
  //Método para desenhar molde do grafico e seus eixos
  void desenharFundo() {
    stroke(55);
    strokeWeight(5);
    fill(1);
    rect(x, y, largura, altura, 5);
    


    stroke(255, 255, 255, 20);
    strokeWeight(1);
    line(x + 10, y + altura/2, x + largura - 10, y + altura/2);
    int[] valoresY = {-2, -1, 0, 1, 2};
      for (int i = 0; i < valoresY.length; i++) {
      int valor = valoresY[i];
      float py = map(valor,  -2, 2, y + altura - 10, y + 10);
        
      stroke(255, 255, 255, 70);
      line(x + largura/13 - 5, py, x + largura - 10, py); // linha horizontal
      fill(255);
      textAlign(RIGHT, CENTER);
      text(nf(valor, 1), x + largura/13 - 10, py); // rótulo do valor
      
      // Título do eixo X (tempo)
      fill(255);
      textAlign(CENTER, TOP);
      text("Tempo (s)", x + largura -45, y + altura + 7); // abaixo do gráfico

      // Título do eixo Y (tensão)
      pushMatrix(); // salva o estado da matriz
      translate(x - 40, y + altura / 2); // posiciona próximo ao eixo Y
      rotate(-HALF_PI); // gira 90° no sentido anti-horário
      textAlign(CENTER, TOP);
      text("Tensão (V)", 20, 50);
      popMatrix(); // retorna ao estado normal
           
}

    //Divisões por segundo
    
    int taxaamostragem = 50; //Arduino está envido dados a cada 20 ms 
    int segundostotais = coletor.maxPontos / taxaamostragem;
    for(int s = 0; s <= segundostotais; s++) {
      float px = map(s * taxaamostragem, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      stroke(255, 255, 255, 70);
      line(px, y, px, y + altura);
      textAlign(CENTER, TOP);
      
          
    }  

    fill(255);
    textAlign(CENTER, TOP);
    text(titulo, x + largura / 2, y + 10);
  }

    //Método para desenhar molde do grafico e seus eixos
  void desenharFundoA() {
    stroke(55);
    strokeWeight(5);
    fill(1);
    rect(x, y, largura, altura, 5);
    


    stroke(255, 255, 255, 20);
    strokeWeight(1);
    line(x + 10, y + altura/2, x + largura - 10, y + altura/2);
    int[] valoresY = {-2, -1, 0, 1, 2};
      for (int i = 0; i < valoresY.length; i++) {
      int valor = valoresY[i];
      float py = map(valor,  -2, 2, y + altura - 10, y + 10);
        
      stroke(255, 255, 255, 70);
      line(x + largura/13 - 5, py, x + largura - 10, py); // linha horizontal
      fill(255);
      textAlign(RIGHT, CENTER);
      text(nf(valor, 1), x + largura/13 - 10, py); // rótulo do valor
      
      // Título do eixo X (tempo)
      fill(255);
      textAlign(CENTER, TOP);
      text("Tempo (s)", x + largura -45, y + altura + 10); // abaixo do gráfico

      // Título do eixo Y (tensão)
      pushMatrix(); // salva o estado da matriz
      translate(x - 40, y + altura / 2); // posiciona próximo ao eixo Y
      rotate(-HALF_PI); // gira 90° no sentido anti-horário
      textAlign(CENTER, TOP);
      text("Corrente (mA)", 50, 50);
      popMatrix(); // retorna ao estado normal
           
}

    //Divisões por segundo
    
    int taxaamostragem = 50; //Arduino está envido dados a cada 20 ms 
    int segundostotais = coletor.maxPontos / taxaamostragem;
    for(int s = 0; s <= segundostotais; s++) {
      float px = map(s * taxaamostragem, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      stroke(255, 255, 255, 70);
      line(px, y, px, y + altura);
      textAlign(CENTER, TOP);

    
    }  

    fill(255);
    textAlign(CENTER, TOP);
    text(titulo, x + largura / 2, y + 10);
  }
  

  //Método para desenhar molde do grafico e seus eixos
  void desenharFundo_Real() {
    stroke(55);
    strokeWeight(5);
    fill(1);
    rect(x, y, largura, altura, 5);
  

    stroke(255, 255, 255, 20);
    strokeWeight(1);
    line(x + 10, y + altura/2, x + largura - 10, y + altura/2); //Ajusta o eixo x nos três gráficos
    int[] valoresY = {-2000, -1000, 0, 1000, 2000};
      for (int i = 0; i < valoresY.length; i++) {
      int valor = valoresY[i];
      float py = map(valor,  -2000, 2000, y + altura - 10, y + 10);
        
      stroke(255, 255, 255, 70);
      line(x + largura/13 - 5, py, x + largura - 10, py); // linha horizontal
      fill(255);
      textAlign(RIGHT, CENTER);
      text(nf(valor, 1), x + largura/13 - 10, py); // rótulo do valor
      
      // Título do eixo X (tempo)
      fill(255);
      textAlign(CENTER, TOP);
      text("Tempo (s)", x + largura -45, y + altura + 7); // abaixo do gráfico

      // Título do eixo Y (tensão)
      pushMatrix(); // salva o estado da matriz
      translate(x - 40, y + altura / 2); // posiciona próximo ao eixo Y
      rotate(-HALF_PI); // gira 90° no sentido anti-horário
      textAlign(CENTER, TOP);
      text("Ohms (Ω)", 20, 50);
      popMatrix(); // retorna ao estado normal
           
}

    //Divisões por segundo
    
    int taxaamostragem = 50; //Arduino está envido dados a cada 20 ms 
    int segundostotais = coletor.maxPontos / taxaamostragem;
    for(int s = 0; s <= segundostotais; s++) {
      float px = map(s * taxaamostragem, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      stroke(255, 255, 255, 70);
      line(px, y, px, y + altura);
      textAlign(CENTER, TOP);

    
    }  

    fill(255);
    textAlign(CENTER, TOP);
    text(titulo, x + largura / 2, y + 10);
}

  //Método para desenhar molde do grafico e seus eixos
  void desenharFundo_Ima() {
    stroke(55);
    strokeWeight(5);
    fill(1);
    rect(x, y, largura, altura, 5);
   


    stroke(255, 255, 255, 20);
    strokeWeight(1);
    line(x + 10, y + altura/2, x + largura - 10, y + altura/2);
    int[] valoresY = {-200, -100, 0, 100, 200};
      for (int i = 0; i < valoresY.length; i++) {
      int valor = valoresY[i];
      float py = map(valor,  -200, 200, y + altura - 10, y + 10);
        
      stroke(255, 255, 255, 70);
      line(x + largura/13 - 5, py, x + largura - 10, py); // linha horizontal
      fill(255);
      textAlign(RIGHT, CENTER);
      text(nf(valor, 1), x + largura/13 - 10, py); // rótulo do valor
      
            // Título do eixo X (tempo)
      fill(255);
      textAlign(CENTER, TOP);
      text("Tempo (s)", x + largura -45, y + altura + 7); // abaixo do gráfico

      // Título do eixo Y (tensão)
      pushMatrix(); // salva o estado da matriz
      translate(x - 40, y + altura / 2); // posiciona próximo ao eixo Y
      rotate(-HALF_PI); // gira 90° no sentido anti-horário
      textAlign(CENTER, TOP);
      text("Ohms (Ω)", 20, 50);
      popMatrix(); // retorna ao estado normal
      
           
}

    //Divisões por segundo
    
    int taxaamostragem = 50; //Arduino está envido dados a cada 20 ms 
    int segundostotais = coletor.maxPontos / taxaamostragem;
    for(int s = 0; s <= segundostotais; s++) {
      float px = map(s * taxaamostragem, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      stroke(255, 255, 255, 70);
      line(px, y, px, y + altura);
      textAlign(CENTER, TOP);

    
    }  

    fill(255);
    textAlign(CENTER, TOP);
    text(titulo, x + largura / 2, y + 10);
  }

  //Método para desenhar molde do grafico e seus eixos
  void desenharFundo_Ampli() {
    stroke(55);
    strokeWeight(5);
    fill(1);
    rect(x, y, largura, altura, 5);



    stroke(255, 255, 255, 20);
    strokeWeight(1);
    line(x + 10, y + altura/2, x + largura - 10, y + altura/2);
    int[] valoresY = {-2000, -1000, 0, 1000, 2000};
      for (int i = 0; i < valoresY.length; i++) {
      int valor = valoresY[i];
      float py = map(valor,  -2000, 2000, y + altura - 10, y + 10);
        
      stroke(255, 255, 255, 70);
      line(x + largura/13 - 5, py, x + largura - 10, py); // linha horizontal
      fill(255);
      textAlign(RIGHT, CENTER);
      text(nf(valor, 1), x + largura/13 - 10, py); // rótulo do valor
      
      // Título do eixo X (tempo)
      fill(255);
      textAlign(CENTER, TOP);
      text("Tempo (s)", x + largura -45, y + altura + 7); // abaixo do gráfico

      // Título do eixo Y (tensão)
      pushMatrix(); // salva o estado da matriz
      translate(x - 40, y + altura / 2); // posiciona próximo ao eixo Y
      rotate(-HALF_PI); // gira 90° no sentido anti-horário
      textAlign(CENTER, TOP);
      text("Ohms (Ω)", 10, 50);
      popMatrix(); // retorna ao estado normal
           
}

    //Divisões por segundo
    
    int taxaamostragem = 50; //Arduino está envido dados a cada 20 ms 
    int segundostotais = coletor.maxPontos / taxaamostragem;
    for(int s = 0; s <= segundostotais; s++) {
      float px = map(s * taxaamostragem, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      stroke(255, 255, 255, 70);
      line(px, y, px, y + altura);
      textAlign(CENTER, TOP);

    
    }  

    fill(255);
    textAlign(CENTER, TOP);
    text(titulo, x + largura / 2, y + 10);
  }

  //Método para desenhar molde do grafico e seus eixos
  void desenharFundo_fase() {
    stroke(55);
    strokeWeight(5);
    fill(1);
    rect(x, y, largura, altura, 5);
    

    stroke(255, 255, 255, 20);
    strokeWeight(1);
    line(x + 10, y + altura/2, x + largura - 10, y + altura/2);
    int[] valoresY = {-20, -10, 0, 10, 20};
      for (int i = 0; i < valoresY.length; i++) {
      int valor = valoresY[i];
      float py = map(valor,  -20, 20, y + altura - 10, y + 10);
        
      stroke(255, 255, 255, 70);
      line(x + largura/13 - 5, py, x + largura - 10, py); // linha horizontal
      fill(255);
      textAlign(RIGHT, CENTER);
      text(nf(valor, 1), x + largura/13 - 10, py); // rótulo do valor
      
            // Título do eixo X (tempo)
      fill(255);
      textAlign(CENTER, TOP);
      text("Tempo (s)", x + largura -45, y + altura + 7); // abaixo do gráfico

      // Título do eixo Y (tensão)
      pushMatrix(); // salva o estado da matriz
      translate(x - 40, y + altura / 2); // posiciona próximo ao eixo Y
      rotate(-HALF_PI); // gira 90° no sentido anti-horário
      textAlign(CENTER, TOP);
      text("Fase (°)", 20, 50);
      popMatrix(); // retorna ao estado normal
           
}

    //Divisões por segundo
    
    int taxaamostragem = 50; //Arduino está envido dados a cada 20 ms 
    int segundostotais = coletor.maxPontos / taxaamostragem;
    for(int s = 0; s <= segundostotais; s++) {
      float px = map(s * taxaamostragem, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      stroke(255, 255, 255, 70);
      line(px, y, px, y + altura);
      textAlign(CENTER, TOP);

    
    }  

    fill(255);
    textAlign(CENTER, TOP);
    text(titulo, x + largura / 2, y + 10);
  }

   //***Converdo modo regangular para polar (Amplitude)***
  void desenharDados() {
    stroke(corLinha);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < coletor.dadosY.size(); i++) {
      float amplitude = sqrt(sq(coletor.dadosY.get(i)) + sq(coletor.dadosY1.get(i)));
      float px = map(i, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      float py = map(amplitude, -2000, 2000, y + altura - 10, y + 10);
      vertex(px, py);
    }
    endShape();
  }
  
  //***Converdo modo retangular para polar (Fase)***
   void desenharDados1() { 
    stroke(corLinha);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < coletor.dadosY1.size(); i++) {
      float fase = degrees(atan2(coletor.dadosY1.get(i), coletor.dadosY.get(i)));
      float px = map(i, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      float py = map(fase, -20, 20, y + altura - 10, y + 10);
      vertex(px, py);
    }
    endShape();
  }
   void desenharDados2() {
    stroke(corLinha);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < coletor.dadosY2.size(); i++) {
      float px = map(i, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      float py = map(coletor.dadosY2.get(i), -2, 2, y + altura - 10, y + 10);
      vertex(px, py);
    }
    endShape();
  }  
   void desenharDados3() {
    stroke(corLinha);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < coletor.dadosY3.size(); i++) {
      float px = map(i, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      float py = map(coletor.dadosY3.get(i), -2, 2, y + altura - 10, y + 10);
      vertex(px, py);
  }
    endShape();
    }
    
   void desenharDados4() {
    stroke(corLinha);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < coletor.dadosY.size(); i++) {
      float px = map(i, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      float py = map(coletor.dadosY.get(i), -2000, 2000, y + altura - 10, y + 10);
      vertex(px, py);
    }
    endShape();
    }
   void desenharDados5() {
    stroke(corLinha);
    strokeWeight(2);
    noFill();
    beginShape();
    for (int i = 0; i < coletor.dadosY1.size(); i++) {
      float px = map(i, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      float py = map(coletor.dadosY1.get(i), -200, 200, y + altura - 10, y + 10);
      vertex(px, py);  
    }
    endShape();
   }
}

//Classe estatisticas
class Estatistica {
  void desenhar(float media, float desvio, float variancia, float maximo, float minimo, float Vpp, float media1, float desvio1, float variancia1, float maximo1, float minimo1, float Vpp1) {
    int x = 1000, y = 500;
    stroke(55);
    strokeWeight(2);
    fill(1);
    rect(x +120, 165, 260, 360, 5);

    fill(255);
    textAlign(CENTER, TOP);
    text("Indicadores Estatísticos", x + 470 / 2, y - 300);

    textAlign(LEFT, TOP);
    int margem = x + 120;
    int linha = y -250;
    int esp = 40;
    text("Média (x̅): " + nf(media, 1, 3), margem +10, linha);
    text("Desvio Padrão (s): " + nf(desvio, 1, 3), margem +10, linha + esp);
    text("Variância (s²): " + nf(variancia, 1, 3), margem +10, linha + esp * 2);
    text("Máximo: " + nf(maximo, 1, 3), margem +10, linha + esp * 3);
    text("Mínimo: " + nf(minimo, 1, 3), margem +10, linha + esp * 4);
    text("Vpp: " + nf(Vpp), margem +10, linha + esp * 5);
    
    int x1 = 1000, y1 = 500;
    stroke(55);
    strokeWeight(2);
    fill(1);
    rect(x +120, 550, 260, 360, 5);

    fill(255);
    textAlign(CENTER, TOP);
    text("Indicadores Estatísticos", x + 470 / 2, y + 80);

    textAlign(LEFT, TOP);
    int margem1 = x1 + 120;
    int linha1 = y1 -250;
    int esp1 = 40;
    text("Média (x̅): " + nf(media1, 1, 3), margem1 +10, linha1 + 380);
    text("Desvio Padrão (s): " + nf(desvio1, 1, 3), margem1 +10, linha1 + esp + 380);
    text("Variância (s²): " + nf(variancia1, 1, 3), margem1 +10, linha1 + esp * 2 + 380);
    text("Máximo: " + nf(maximo1, 1, 3), margem1 +10, linha1 + esp1 * 3 + 380);
    text("Mínimo: " + nf(minimo1, 1, 3), margem1 +10, linha1 + esp1 * 4 + 380);
    text("Vpp: " + nf(Vpp1), margem +10, linha + esp * 5 + 380);
  }
}

//Classe Botão
class Botao {
  int x, y, w, h; //Atributo da posição
  String texto; //Atributo texto
  int corNormal, corHover; //Atributo cor
  boolean pressionado = false;
  boolean iniciarPressionado = false;


  Botao(int x, int y, int w, int h, String texto, int corNormal, int corHover) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.texto = texto;
    this.corNormal = corNormal;
    this.corHover = corHover;
  }
  
  //Método desenha o botão da na tela e muda a cor se o mouse estiver sobre ele
  void desenhar() {
    
    fill(estaSobre(mouseX, mouseY) ? corHover : corNormal);
    stroke(0);
    strokeWeight(1);
    rect(x, y, w, h, 5);
    fill(255);
    textAlign(CENTER, BOTTOM);
    text(texto, x + w / 2, y + h -10);
   
  }
  
  //Verifica se o mouse está sobre o mouse
  boolean estaSobre(int mx, int my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}

//Classe coletor serial
class ColetorSerial {
  Serial porta; //Atributo - canal de comunjicação
  ArrayList<Float> dadosY = new ArrayList<Float>();  //Dados da componente real
  ArrayList<Float> dadosY1 = new ArrayList<Float>(); //Dados da componente imaginária
  ArrayList<Float> dadosY2 = new ArrayList<Float>(); //Dados da senoide 1
  ArrayList<Float> dadosY3 = new ArrayList<Float>(); // Dados da senoide 2
  
  int maxPontos = 900;
  Interface ui;
  
  //Construtor
  ColetorSerial(PApplet parent, Interface ui) {
    this.ui = ui;
    println(Serial.list());
    porta = new Serial(parent, Serial.list()[0], 9600);
    porta.bufferUntil('\n'); //Leitura linha por linha
    loop();
  }

  //Lê uma linha de texto recebido do arduino
  //Converte em float
  //Armazena na lista de dados. Maximo permitido são 900 pontos. Se ultrapassar, remove os mais antigos.
  void receberDados(Serial p) { 
    String linha = trim(p.readStringUntil('\n'));
    if (linha != null && linha.length() > 0 && ui.coletando) {
      try {
          String[] partes = split(linha, ',');
          if (partes.length == 4) {
            float Y = float(partes[0]);
            float Y1 = float(partes[1]);
            float Y2 = float(partes[2]);
            float Y3 = float(partes[3]);

            dadosY.add(Y);
            dadosY1.add(Y1);
            dadosY2.add(Y2);
            dadosY3.add(Y3);

            if (dadosY.size() > maxPontos) dadosY.remove(0);   //Dados da componente real
            if (dadosY1.size() > maxPontos) dadosY1.remove(0); // Dados da componente imaginária
            if (dadosY2.size() > maxPontos) dadosY2.remove(0); // Senoide 1
            if (dadosY3.size() > maxPontos) dadosY3.remove(0); // Senoide 2
    }
      } catch (Exception e) {
        println("Erro ao converter valor: " + linha);
      }
    }
  }
}
