 import processing.pdf.*;

 // Importações
 import processing.serial.*;

 Interface interfaceGrafica;
 ColetorSerial coletor;
 int tela = 0; //Variável global
 Menu menu; // Variável global
 Home home;
 String idioma = "PT";
 boolean dadosexternos = true;

 void setup() {
  size(1400, 960); //Definição do tamanho da tela
  menu = new Menu();
  home = new Home();

}
     
 void draw() {
  background(255);
  
  if (tela == 0){
      home.desenharHome();
  }
  
  else if (tela == 1) {
          
          menu.desenharTelaInicial();
          menu.desenharRelogio_data();
          menu.escrevertitulosmenu();
          menu.desenharcirculotrigon(180, height - 180, false);
          menu.desenharcirculotrigon(width - 180, height - 180, true);
    
  }
  else if (tela == 2) {
               
          interfaceGrafica.desenharFundo();
          interfaceGrafica.desenharGraficos();
          Simulador.atualizar();

           if (interfaceGrafica.coletando) {
              //interfaceGrafica.dadoEstatistico();
              //interfaceGrafica.dadoEstatistico1();
    }
  }
}


void mousePressed() {                                                
  
  if(tela == 0 ){
     //Verifica se algum botão foi clicado.
     
        if (mouseX > 550 && mouseX < 850 &&
            mouseY > 470 && mouseY < 590) {  
            idioma = "EN";
            menu = new Menu();
            menu.escrevertitulosmenu();
            tela = 1; // muda para a interface principal
      
      }
      
        if (mouseX > 550 && mouseX < 850 &&
            mouseY > 600 && mouseY < 720) {
            idioma = "PT";
            menu = new Menu();
            menu.escrevertitulosmenu();;
            tela = 1; // muda para a interface principal
     }
  }
  
  else if (tela == 1) {
    
    // Verifica se clicou no botão "Medidor" na tela Menu
        if (mouseX > 395 && mouseX < 695 &&
            mouseY > 470 && mouseY < 590) {
            
           dadosexternos = true;   
           tela = 2;// Muda para a interface principal
           interfaceGrafica = new Interface();
           interfaceGrafica.criarbotoesegraficos();  
           coletor = new ColetorSerial(this, interfaceGrafica);
    }
    
     // Verifica se clicou no botão "Simulador" na tela Menu
        else if (mouseX > 705 && mouseX < 1005 &&
                mouseY > 470 && mouseY < 560) {
            
           dadosexternos = false;      
           tela = 2;// Muda para a interface principal
           interfaceGrafica = new Interface();
           interfaceGrafica.criarbotoesegraficos();  
           coletor = new ColetorSerial(this, interfaceGrafica);
    }
    
    // Verifica se clicou no botão "Voltar" na tela Menu
        else if (mouseX > 550 && mouseX < 850 &&
                mouseY > 780 && mouseY < 880) {
           tela = 0;

     }
  }
        else if (tela == 2 && interfaceGrafica != null) {

            interfaceGrafica.tratarClique(mouseX, mouseY);      
    }
  }


void mouseMoved() {
  redraw();
}

void serialEvent(Serial p) {
  coletor.receberDados(p);
}

// Classe responsável por controlar todos os elementos da tela: botões, gráficos, texto

class Home{
  PFont frotulos, ftitulo;
  PImage idiomaenLogo, idiomaptLogo;
  Botao botaoEnglish, botaoPortugues;
  
  String Ingles      = "English"; 
  String Portugues   = "Português";

  Home () { //Construtor: Objetos criados e personalizados
    frotulos    = createFont("Arial", 35);
    ftitulo     = createFont("Arial", 45);
    
    botaoEnglish   = new Botao(550, 470, 300, 120,   "English",   color(120), color(20, 180, 70));
    botaoPortugues = new Botao(550, 600, 300, 120,   "Português", color(120), color(20, 180, 70));
    
 }

  void desenharHome(){
    background(255);
        
    //Retangulos para o painel central e o lateral esquerdo
    fill(60);
    rect(10, 150, 1380, 800, 5);
    
    textFont(frotulos);
    botaoEnglish.desenhar();
    botaoPortugues.desenhar();
    
    idiomaenLogo = loadImage("idiomaEN.png");
    idiomaptLogo = loadImage("idiomaPT.png");
    
    idiomaenLogo.resize(130, 0);
    idiomaptLogo.resize(130, 0);
        
    fill(20, 180, 70);
    rect(475, 360, 450, 80, 5);
    fill(255);
    noStroke();
    rect(485, 370, 430, 1, 5);
    rect(485, 430, 430, 1, 5);
    
    textFont(ftitulo);
    textAlign(LEFT, TOP);
    text("Selecione/Select:", 525, 385);
    
    image(idiomaenLogo, 650, 390);
    image(idiomaptLogo, 650, 520);
    
  }
}

class Menu {
  PFont   f, fonteTitulo, frotulos, fonteeixo, ftitulo, frodape; //fonte e imagem
  PImage imgLogo, imgSimulador, imgMedidor, imgVoltar;
  Botao botaomedidor, botaosimulador, botaoEnglish, botaoPortugues, botaovoltar;
  
  String mesabreviado;
  String voltarPT    = "Voltar";
  String voltarEN    = "Return";
  String tituloPT    = "Interface gráfica de monitoramento\n   para medidor de bioimpedância"; 
  String tituloEN    = "    Graphical monitoring interface\n          for bioimpedance meter";
  String avisoPT     = "Uso exclusivamente acadêmico por alunos, professores e técnicos. Proibido uso clínico!";
  String avisoEN     = "For academic use only by students, faculty, and technical staff. Clinical use is prohibited!";
  String medidorPT   = "Medidor";
  String medidorEN   = "Meter";
  String simuladorPT = "Simulador";
  String simuladorEN = "Simulator";
  String modoPT      = "Modo:";
  String modoEN      = "Mode:"; 
  String bemvindoPT  = "Bem-vindo(a)";
  String bemvindoEN  = "Welcome";
  String selecionePT = "Selecione o modo de operação:";
  String selecioneEN = "Select the mode of operation:";
  
  String txtMedidor()   { return idioma.equals("PT") ? medidorPT   : medidorEN;   }
  String txtSimulador() { return idioma.equals("PT") ? simuladorPT : simuladorEN; }
  String txtVoltar()    { return idioma.equals("PT") ? voltarPT    : voltarEN;    }
  String txtTitulo()    { return idioma.equals("PT") ? tituloPT    : tituloEN;    }
  String txtBemvindo()  { return idioma.equals("PT") ? bemvindoPT  : bemvindoEN;  }
  String txtModo()      { return idioma.equals("PT") ? modoPT      : modoEN;      }
  String txtSelecione() { return idioma.equals("PT") ? selecionePT : selecioneEN; }
  String txtAviso()     { return idioma.equals("PT") ? avisoPT     : avisoEN;     }
  
  int     dia;
  int     mes;
  
  // Variáveis de controle do regóio e data
  int   cx, cy;
  float segundoRad, minutoRad, horarioRad, Diametrorelogio, raio;
  float angle = 0;
  float radius = 100;
  
    
  Menu () { //Construtor: Objetos criados e personalizados
    f            = createFont("Arial", 55);
    ftitulo      = createFont("Arial", 45);
    frotulos     = createFont("Arial", 35);
    frodape      = createFont("Arial", 20);
    
    imgLogo      = loadImage("Logo.png");
    imgSimulador = loadImage("Simulador.png");
    imgMedidor   = loadImage("Medidor.png");
    imgVoltar    = loadImage("Voltar.png");

    imgLogo.resize(150, 0);
    imgSimulador.resize(180, 0);
    imgMedidor.resize(140, 0);
    imgVoltar.resize(140, 0);
    
    // Posição e tamanho do relógio
    cx = 1310;      // posição no canto superior direito
    cy = 70;
    
    Diametrorelogio = 100;
    raio            = Diametrorelogio / 2;
    segundoRad      = raio * 0.90;
    minutoRad       = raio * 0.70;
    horarioRad      = raio * 0.50;    
    
    botaomedidor   = new Botao(395, 470, 300, 120,   txtMedidor(),   color(120), color(20, 180, 70));
    botaosimulador = new Botao(705, 470, 300, 120,   txtSimulador(), color(120), color(20, 180, 70));
    botaovoltar    = new Botao(550, 780, 300, 100,   txtVoltar(),    color(120), color(70, 130, 180));
        
   }
   
void escrevertitulosmenu() {
  
      textFont(f);
      fill(13, 98, 58);
      textAlign(LEFT, TOP);
      text(txtTitulo(), 240, 30);
      
      fill(255);
      textFont(f);
      textAlign(CENTER, CENTER);
      text(txtBemvindo(), width/2, 210);
      textFont(ftitulo);
      text(txtSelecione(), width/2, 270);
      textFont(ftitulo);
      textAlign(CENTER, CENTER);
      text(txtModo(), width/2, 400);
      textFont(frodape);
      //textAlign(CENTER, CENTER);
      text(txtAviso(), width/2, 920);
      
}

void desenharcirculotrigon(float cx, float cy, boolean espelhado) {
  
    float ang = radians(angle);

    // se espelhado = true, inverte o cos (que controla o eixo X)
    float px = cx + radius * cos(ang) * (espelhado ? -1 : 1);
    float py = cy + radius * sin(ang);

    // --- CÍRCULO TRIGONOMÉTRICO ---
    stroke(255);
    strokeWeight(3);
    noFill();
    ellipse(cx, cy, radius*2, radius*2);

    // Eixos
    stroke(20, 180, 70);
    line(cx - radius, cy, cx + radius, cy);
    stroke(255);
    line(cx, cy - radius, cx, cy + radius);

    // projeções
    stroke(255);
    line(px, cy, px, py); // seno
    stroke(20, 180, 70);
    line(cx, py, px, py); // cosseno

    // ponto no círculo
    fill(255);
    noStroke();
    ellipse(px, py, 15, 15);

    // círculos do seno e cosseno
    fill(20, 180, 70);
    ellipse(px, cy - 130, 45, 45);

    fill(255);
    ellipse(cx -135 * (espelhado ? -1 : 1), py, 45, 45);

    angle -= 1.5;
  
  }
  
void desenharTelaInicial() {
    background(255);
    
    image(imgLogo, 30, 10);
        
    //Retangulos para o painel central e o lateral esquerdo
    fill(60);
    rect(10, 150, 1375, 800, 5);
          
    textFont(frotulos);
    fill(13, 98, 58);
            
    botaomedidor.desenhar();
    botaosimulador.desenhar();
    botaovoltar.desenhar();
    
    image(imgSimulador, 760, 410);
    image(imgMedidor,   465, 415);
    image(imgVoltar,    630, 720);
        
    int h          = hour();
    int m          = minute();
    int s          = second();
    String horario = nf(h, 2) + ":" + nf(m, 2) + ":" + nf(s, 2);
    
    fill(20, 180, 70);
    rect(575, 360, 250, 80, 5);
    fill(255);
    noStroke();
    rect(585, 370, 230, 1, 5);
    rect(585, 430, 230, 1, 5);
    
    textFont(ftitulo);
    fill(255);
    textAlign(LEFT, TOP);
      
}
    
  void desenharRelogio_data() {
    
     stroke(0);
     strokeWeight(2);
     fill(255);
     rect(1140, 20, 110, 60, 5);
     fill(20, 180, 70);
     rect(1140, 80, 110, 40, 2);
     fill(255);
     noStroke();
     rect(1145, 115, 100, 1, 10);
     fill(0);
     rect(1160, 17, 5, 10, 2);
     rect(1195, 17, 5, 10, 2);
     rect(1230, 17, 5, 10, 2);

     dia = day();
     mes = month();
     
     String[] meses = {"Jan.", "Fev.", "Mar.", "Abr.", "Maio", "Jun.", "Jul.", "Ago.", "Set.", "Out.", "Nov.", "Dez."};
     mesabreviado = meses[mes - 1]; 
     
     textFont (f);
     fill     (13, 98, 58);
     textAlign(LEFT, TOP);
     text     (dia, (1130 + 1200)/2, 33);
     
     textFont(frotulos);
     fill    (255);
     text    (mesabreviado, 1165, 85);
     
     pushMatrix  ();
     translate   (cx, cy);
     fill        (255);
     stroke      (0);
     strokeWeight(4);
     ellipse     (0, 0, Diametrorelogio, Diametrorelogio);
          
     // Angles for sin() and cos() start at 3 o'clock;
     // subtract HALF_PI to make them start at the top
     float s = map(second(), 0, 60, 0, TWO_PI) - HALF_PI;
     float m = map(minute() + norm(second(), 0, 60), 0, 60, 0, TWO_PI) - HALF_PI; 
     float h = map(hour  () + norm(minute(), 0, 60), 0, 24, 0, TWO_PI * 2) - HALF_PI;
  
     //Ponteiros do relógio
     stroke      (80);
     strokeWeight(1);
     line        (0, 0, cos(s) * segundoRad, sin(s) * segundoRad);
     strokeWeight(3);
     line        (0, 0, cos(m) * minutoRad, sin(m) * minutoRad);
     strokeWeight(5);
     line        (0, 0, cos(h) * horarioRad, sin(h) * horarioRad);
  
     // Marcação 
     stroke(80);
     strokeWeight(1);
     beginShape(POINTS);
     for (int a = 0; a < 360; a+=6) {
       float angle = radians(a);
       float x     = cx + cos(angle) * segundoRad;
       float y     = cy + sin(angle) * segundoRad;
       vertex(x, y);
    }

     popMatrix();
  
    // Hora digital
    String horario = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    textAlign(CENTER, TOP);
    fill(0);
    textSize(22);
    text(horario, cx, cy + Diametrorelogio / 2 + 10);
   
  }
 }

// Classe responsável por controlar todos os elementos da tela: botões, fráficos, texto
class Interface {
  PFont f, fonteTitulo, frotulos, fonteeixo; //fonte e imagem
  PImage imgLogo, imgpause, imgstart, iconepausa, imgpolar, imgPausa, imgSeno, imgZ, imgRet, imgRei, imgMenu;
  
  Grafico grafico1, grafico2, grafico3, grafico4, grafico5, grafico6; //Objetos da classe Grafico
  Estatistica estatistica; Estatistica estatistica1;//atributo da class
  Botao botaoIniciar, botaoParar, botaoImpedancia, botaoSinais, botaoRet, botaoPol, botaoMenu, botaoRestart; //Objetos da classe Botão
  Simulador realsimulado, imaginsimulado, tensaosimulado, correntesimulado, polarsimulado, amplitudesimulado;
  
  int abaAtual       = 2; //Impedancia, 1 = Sinais Medidos
  int tsEstatistico  = 0;
  int tsEstatistico1 = 0;
  int intEstatistico = 2000;
  int altbotao       = 95;
  int larbotao       = 160;
  int larbotaomenor  = 132;
  
  float media, desvio, variancia, maximo, minimo, Max_valor, Min_valor, valorpp, Vpp, media1, desvio1, variancia1, maximo1, minimo1, Max_valor1, Min_valor1, valorpp1, Vpp1;
  boolean impedanciaPressionado, iniciarPressionado, retPressionado, polPressionado, sinalPressionado, pararPressionado, menuPressionado, restartPressionado, coletando;   
  
  color linhaverde = color(20, 180, 70);
  color linhaazul  = color(100, 116, 230);

  String tituloPT          = "Interface gráfica de monitoramento\n   para medidor de bioimpedância"; 
  String tituloEN          = "    Graphical monitoring interface\n          for bioimpedance meter"; 
  String iniciarPT         = "Iniciar";
  String iniciarEN         = "Start";
  String pararPT           = "Parar";
  String pararEN           = "Stop";
  String tensaocorrentePT  = "Tensão/Corrente";
  String tensaocorrenteEN  = "Voltage/Current"; 
  String polarPT           = "Polar";
  String polarEN           = "Polar";
  String retangularPT      = "Retangular";
  String retangularEN      = "Rectangular";
  String menuPT            = "Menu";
  String menuEN            = "Menu";
  String reiniciarPT       = "Reiniciar";
  String reiniciarEN       = "Restart";
  String impedanciaPT      = "Impedância";
  String impedanciaEN      = "Impedance";
  String modofasePT        = "Modo Polar - Fase";
  String modofaseEN        = "Polar Mode - Phase";
  String modoamplitudePT   = "Modo Polar - Amplitude";
  String modoamplitudeEN   = "Polar Mode - Amplitude";
  String modotensaoPT      = "Sinais Medidos - Tensão";
  String modotensaoEN      = "Measured Signals - Voltage";
  String modocorrentePT    = "Sinais Medidos - Corrente";
  String modocorrenteEN    = "Measured Signals - Current";
  String modoretrealPT     = "Modo Retangular - Real";
  String modoretrealEN     = "Rectangular Mode - Real";
  String modoretimaPT      = "Modo Retangular - Imaginário"; 
  String modoretimaEN      = "Rectangular Mode - Imaginary";
  String modoPT            = "Modo";
  String modoEN            = "Mode";
  String sinalPT           = "Sinal";
  String sinalEN           = "Signal";
  String coletaPT          = "Coletar";
  String coletaEN          = "Collect"; 
  
  String txtTitulo()       { return idioma.equals("PT") ? tituloPT : tituloEN; }
  String txtSinal()        { return idioma.equals("PT") ? sinalPT  : sinalEN;  }
  String txtModo()         { return idioma.equals("PT") ? modoPT   : modoEN;   }
  String txtColeta()       { return idioma.equals("PT") ? coletaPT : coletaEN; }
  
  String txtAmplitude()       { return idioma.equals("PT") ? modoamplitudePT : modoamplitudeEN; }
  String txtFase()            { return idioma.equals("PT") ? modofasePT      : modofaseEN;      }
  String txtTensao()          { return idioma.equals("PT") ? modotensaoPT    : modotensaoEN;    }
  String txtCorrente()        { return idioma.equals("PT") ? modocorrentePT  : modocorrenteEN;  }  
  String txtRetangularreal()  { return idioma.equals("PT") ? modoretrealPT   : modoretrealEN;   }
  String txtRetangularima()   { return idioma.equals("PT") ? modoretimaPT    : modoretimaEN;    }
  
  String txtBotaoiniciar()      { return idioma.equals("PT") ? iniciarPT          : iniciarEN;        }
  String txtBotaoparar()        { return idioma.equals("PT") ? pararPT            : pararEN;          }
  String txtbotaoSinais()       { return idioma.equals("PT") ? tensaocorrentePT   : tensaocorrenteEN; }
  String txtBotaopol()          { return idioma.equals("PT") ? polarPT            : polarEN;          }  
  String txtBotaoret()          { return idioma.equals("PT") ? retangularPT       : retangularEN;     }
  String txtBotaomenu()         { return idioma.equals("PT") ? menuPT             : menuEN;           }
  String txtBotaorestart()      { return idioma.equals("PT") ? reiniciarPT        : reiniciarEN;      }
  String txtBotaoimpedancia()   { return idioma.equals("PT") ? impedanciaPT       : impedanciaEN;     }
   
  Interface() { //Construtor: Objetos criados e personalizados
    f           = createFont("Arial", 55);
    frotulos    = createFont("Arial", 35);
    fonteTitulo = createFont("Arial", 20);
    fonteeixo   = createFont("Arial", 15);
    imgLogo     = loadImage("Logo.png");
    imgstart    = loadImage("start.png");
    imgPausa    = loadImage("Pausa.png");
    imgSeno     = loadImage("Seno.png");
    imgpolar    = loadImage("imgpolar.png");
    imgZ        = loadImage("imgZ.png");
    imgRet      = loadImage("imgRet.png");
    imgRei      = loadImage("Reiniciar.png");
    imgMenu     = loadImage("Menu.png");
    
    imgLogo.resize (150, 0);
    imgstart.resize(110, 0);
    imgPausa.resize(70, 0);
    imgSeno.resize (130,0);
    imgpolar.resize(400,0);
    imgZ.resize    (350,0);
    imgRet.resize  (350,0);
    imgRei.resize  (50, 0);
    imgMenu.resize (70, 0);
}

  void criarbotoesegraficos() {
  
       grafico1 = new Grafico(195, 165, color(linhaverde), txtAmplitude());
       grafico2 = new Grafico(195, 550, color(linhaazul),  txtFase());
       grafico3 = new Grafico(195, 165, color(linhaverde), txtTensao());
       grafico4 = new Grafico(195, 550, color(linhaazul),  txtCorrente());
       grafico5 = new Grafico(195, 165, color(linhaverde), txtRetangularreal());
       grafico6 = new Grafico(195, 550, color(linhaazul),  txtRetangularima());
    
       estatistica     = new Estatistica();
       
       botaoIniciar    = new Botao(15, 755,  larbotao, altbotao,       txtBotaoiniciar(),    color(120), color(20, 180, 70));
       botaoParar      = new Botao(15, 850,  larbotao, altbotao,       txtBotaoparar(),      color(120), color(200, 70, 70));
       botaoSinais     = new Botao(15, 228,  larbotao, altbotao,       txtbotaoSinais(),     color(120), color(20, 180, 70));
       botaoPol        = new Botao(15, 486,  larbotao, altbotao,       txtBotaopol(),        color(120), color(20, 180, 70));
       botaoRet        = new Botao(15, 581,  larbotao, altbotao,       txtBotaoret(),        color(120), color(20, 180, 70));    
       botaoMenu       = new Botao(1255, 40, larbotaomenor, altbotao,  txtBotaomenu(),       color(120), color(70, 130, 180)); 
       botaoRestart    = new Botao(1120, 40, larbotaomenor, altbotao,  txtBotaorestart(),    color(120), color(20, 180, 70));
       botaoImpedancia = new Botao(15, 323,  larbotao, altbotao,       txtBotaoimpedancia(), color(120), color(20, 180, 70));
  
}
  
  void desenharFundo() { //Método. Desenha a estrutura visual da inteface
  
    textFont(f);
    fill(13, 98, 58);
    textAlign(LEFT, TOP);
    text(txtTitulo(), 240, 30);
    image(imgLogo, 30, 10);

    textFont(fonteTitulo);
    fill(255);
    textAlign(CENTER, TOP);
  
    //Retangulos para o painel central e o lateral esquerdo
    fill(60);
    rect(190, 150, 1200, 800, 5);
    rect(10, 150, 170, 800, 5);
    fill(255);
    rect(15, 165, 160, 253, 5);
    rect(15, 423, 160, 253, 5);
    rect(15, 681, 160, 253, 5);
          
    textFont(frotulos);
    fill(13, 98, 58);
    textAlign(CENTER, TOP);
    text(txtSinal(), 15 + 160/2, 165 + 22);
    text(txtModo(),   15 + 160/2, 423 + 22);
    text(txtColeta(), 15 + 160/2, 681 + 25);

    textFont(fonteTitulo);
    
    estatistica.desenhar(media, desvio, variancia, maximo, minimo, Vpp, media1, desvio1, variancia1, maximo1, minimo1, Vpp1);
    botaoIniciar.desenhar();
    botaoParar.desenhar();
    botaoImpedancia.desenhar();
    botaoSinais.desenhar();
    botaoRet.desenhar();
    botaoPol.desenhar();
    botaoMenu.desenhar();
    botaoRestart.desenhar();
    
    image(imgstart, 58,   702);
    image(imgPausa, 60,   828);
    image(imgSeno,  30,   155);
    image(imgpolar, -95,  198);
    image(imgZ,     -60,  60);
    image(imgRei,   1160, 30);
    image(imgMenu,  1285, 15);
    image(imgRet,   -60,  320);
        
    if (polPressionado){
      grafico1.desenharFundo_Ampli(); 
      grafico2.desenharFundo_fase(); 
    }
    
    if (retPressionado){
      grafico5.desenharFundo_Real(); 
      grafico6.desenharFundo_Ima();
      
    }
    
    if (sinalPressionado){
      grafico3.desenharFundoV();
      grafico4.desenharFundoA();
    }
        
    textAlign(LEFT, CENTER);
    textSize(18);
  
  }

 void desenharGraficos() {

  if (!iniciarPressionado || !coletando) return; 
  
  boolean usandoSerial = dadosexternos && coletor != null;

  // --- RETANGULAR ---
  if (retPressionado && impedanciaPressionado) {
    
    if (usandoSerial) {
      grafico5.desenharDados(coletor.dadosY,  -450, 450, linhaverde); 
      grafico6.desenharDados(coletor.dadosY1, -60,   60,  linhaazul );
      interfaceGrafica.dadoEstatisticoReal();
      interfaceGrafica.dadoEstatisticoImaginario();
    } else {
      grafico5.desenharDados(Simulador.getReal(),  -450, 450, linhaverde);
      grafico6.desenharDados(Simulador.getImag(), -60,  60, linhaazul );
      interfaceGrafica.dadoEstatisticoReal();
      interfaceGrafica.dadoEstatisticoImaginario();
    }
  }

  // --- POLAR ---
  else if (polPressionado && impedanciaPressionado) {

    if (usandoSerial) {
      grafico1.desenharDados(coletor.dadosY4, -450, 450, linhaverde);  
      grafico2.desenharDados(coletor.dadosY5,  -8,   8,  linhaazul );
      interfaceGrafica.dadoEstatisticoAmplitude();
      interfaceGrafica.dadoEstatisticoFase();
    } else {
      grafico1.desenharDados(Simulador.getPolar(), -450, 450, linhaverde);  
      grafico2.desenharDados(Simulador.getFase(),   -60,  60, linhaazul );
      interfaceGrafica.dadoEstatisticoAmplitude();
      interfaceGrafica.dadoEstatisticoFase();
    }
  }

  // --- TENSÃO / CORRENTE ---
  else if (sinalPressionado) {
    
    if (usandoSerial) {
      grafico3.desenharDados(coletor.dadosY2,  -2, 2, linhaverde); 
      grafico4.desenharDados(coletor.dadosY3,  -2, 2, linhaazul  );
      interfaceGrafica.dadoEstatisticoTensao();
      interfaceGrafica.dadoEstatisticoCorrente();
    } else {
      grafico3.desenharDados(Simulador.getTensao(),    -2, 2, linhaverde);  
      grafico4.desenharDados(Simulador.getCorrente(), -2, 2, linhaazul );
      interfaceGrafica.dadoEstatisticoTensao();
      interfaceGrafica.dadoEstatisticoCorrente();

    }
  }
} 

  //Verifica se algum botão foi clicado. 
 void tratarClique(int x, int y) {
    if (botaoIniciar.estaSobre(x, y)) {
       iniciarPressionado   = true;
       botaoIniciar.Ativo   = true;
       botaoParar.Parado    = false;
       pararPressionado     = false;
       menuPressionado      = false;
       restartPressionado   = false;

    }
    
    if (botaoRet.estaSobre(x, y)) {
       retPressionado      = true;
       botaoRet.Ativo      = true;
       botaoPol.Ativo      = false;
       botaoSinais.Ativo   = false;
       polPressionado      = false;
       menuPressionado     = false;
       restartPressionado  = false;    
       
    }

    if (botaoPol.estaSobre(x, y)) {
       polPressionado     = true;
       botaoPol.Ativo     = true;
       botaoRet.Ativo     = false;
       botaoSinais.Ativo  = false;
       retPressionado     = false;
       menuPressionado    = false;
       restartPressionado = false;
       
    }
    
    if (botaoSinais.estaSobre(x, y)) {
       sinalPressionado      = true;
       botaoSinais.Ativo     = true;
       botaoPol.Ativo        = false;
       botaoRet.Ativo        = false;
       botaoImpedancia.Ativo = false;
       polPressionado        = false;
       retPressionado        = false;
       menuPressionado       = false;
       restartPressionado    = false;
       
    }
    
    if (botaoImpedancia.estaSobre(x, y)){
       impedanciaPressionado = true;
       botaoImpedancia.Ativo = true;
       botaoSinais.Ativo     = false;
       sinalPressionado      = false;
       menuPressionado       = false;
       restartPressionado    = false;
       
    }
    
    // Iniciar coleta apenas se "Iniciar" e pelo menos um dos outros dois estiverem pressionados
    if (iniciarPressionado && (retPressionado || polPressionado || sinalPressionado)) {
       coletando          = true;
       menuPressionado    = false;
       restartPressionado = false;
       
  }

    if (botaoParar.estaSobre(x, y)) {
       botaoParar.Parado     = true;
       botaoIniciar.Ativo    = false;
       botaoSinais.Ativo     = false;
       botaoImpedancia.Ativo = false;
       botaoRet.Ativo        = false;
       botaoPol.Ativo        = false;
       coletando             = false;
       menuPressionado       = false;
       restartPressionado    = false;
      
  }
  
    if (botaoRestart.estaSobre(x, y)) {
       coletando             = false;
       iniciarPressionado    = false;
       retPressionado        = false;
       polPressionado        = false;
       sinalPressionado      = false;
       impedanciaPressionado = false;
       menuPressionado       = false;
       pararPressionado      = false;
       sinalPressionado      = false;
       
       botaoSinais.Ativo     = false;
       botaoIniciar.Ativo    = false;
       botaoParar.Parado     = false;
       botaoRet.Ativo        = false;
       botaoPol.Ativo        = false;
       botaoImpedancia.Ativo = false;
       
       if (coletor != null) {
           coletor.dadosY.clear();
           coletor.dadosY1.clear();
           coletor.dadosY2.clear();
           coletor.dadosY3.clear();
    }
  
}
    if (botaoMenu.estaSobre(x, y)) {
       coletando             = false;
       iniciarPressionado    = false;
       retPressionado        = false;
       polPressionado        = false;
       sinalPressionado      = false;
       impedanciaPressionado = false;
       restartPressionado    = false;
       botaoIniciar.Ativo    = false;
       botaoParar.Parado     = false;
       botaoSinais.Ativo     = false;
       botaoRet.Ativo        = false;
       botaoPol.Ativo        = false;
       botaoImpedancia.Ativo = false;
         
    if (coletor != null && coletor.porta != null) {
       coletor.porta.stop(); // OU coletor.porta.clear(); coletor.porta.dispose(); 
       coletor.porta = null;
       tela = 1;       
  }
      
      //tela = 0;
      
  }
  redraw();
  
}

 void dadoEstatisticoReal() {
   if (millis() - tsEstatistico > intEstatistico && coletor.dadosY.size() >= 100) {  //millis retorna o tempo atual desde que o código iniciou
     ArrayList<Float> ultimos = new ArrayList<Float>();
     for (int i = coletor.dadosY.size() - 100; i < coletor.dadosY.size(); i++) {
        ultimos.add(coletor.dadosY.get(i));
      }
      
      float soma = 0;
      float max  = -Float.MAX_VALUE;
      float min  = Float.MAX_VALUE;
         
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
      media     = mediaLocal;
      variancia = somaQuadrado / ultimos.size();
      desvio    = sqrt(variancia);
      maximo    = max;
      minimo    = min;
      Vpp       = valorpp;
      
      tsEstatistico = millis();
      }
   }
   
 void dadoEstatisticoImaginario() {
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
      media1     = mediaLocal1;
      variancia1 = somaQuadrado1 / ultimos1.size();
      desvio1    = sqrt(variancia);
      maximo1    = max1;
      minimo1    = min1;
      Vpp1       = valorpp1;
      
      tsEstatistico1 = millis();
      }
   }
   void dadoEstatisticoTensao() {
   if (millis() - tsEstatistico > intEstatistico && coletor.dadosY2.size() >= 100) {  //millis retorna o tempo atual desde que o código iniciou
     ArrayList<Float> ultimos = new ArrayList<Float>();
     for (int i = coletor.dadosY2.size() - 100; i < coletor.dadosY2.size(); i++) {
        ultimos.add(coletor.dadosY2.get(i));
      }
      
      float soma = 0;
      float max  = -Float.MAX_VALUE;
      float min  = Float.MAX_VALUE;
         
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
      media     = mediaLocal;
      variancia = somaQuadrado / ultimos.size();
      desvio    = sqrt(variancia);
      maximo    = max;
      minimo    = min;
      Vpp       = valorpp;
      
      tsEstatistico = millis();
      }
   }
 void dadoEstatisticoCorrente() {
   if (millis() - tsEstatistico1 > intEstatistico && coletor.dadosY3.size() >= 100) {  //millis retorna o tempo atual desde que o código iniciou
     ArrayList<Float> ultimos1 = new ArrayList<Float>();
     for (int i = coletor.dadosY3.size() - 100; i < coletor.dadosY3.size(); i++) {
        ultimos1.add(coletor.dadosY3.get(i));
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
      media1     = mediaLocal1;
      variancia1 = somaQuadrado1 / ultimos1.size();
      desvio1    = sqrt(variancia);
      maximo1    = max1;
      minimo1    = min1;
      Vpp1       = valorpp1;
      
      tsEstatistico1 = millis();
      }
   }

   void dadoEstatisticoAmplitude() {
   if (millis() - tsEstatistico > intEstatistico && coletor.dadosY4.size() >= 100) {  //millis retorna o tempo atual desde que o código iniciou
     ArrayList<Float> ultimos = new ArrayList<Float>();
     for (int i = coletor.dadosY4.size() - 100; i < coletor.dadosY4.size(); i++) {
        ultimos.add(coletor.dadosY4.get(i));
      }
      
      float soma = 0;
      float max  = -Float.MAX_VALUE;
      float min  = Float.MAX_VALUE;
         
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
      media     = mediaLocal;
      variancia = somaQuadrado / ultimos.size();
      desvio    = sqrt(variancia);
      maximo    = max;
      minimo    = min;
      Vpp       = valorpp;
      
      tsEstatistico = millis();
      }
   }
 void dadoEstatisticoFase() {
   if (millis() - tsEstatistico1 > intEstatistico && coletor.dadosY5.size() >= 100) {  //millis retorna o tempo atual desde que o código iniciou
     ArrayList<Float> ultimos1 = new ArrayList<Float>();
     for (int i = coletor.dadosY5.size() - 100; i < coletor.dadosY5.size(); i++) {
        ultimos1.add(coletor.dadosY5.get(i));
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
      media1     = mediaLocal1;
      variancia1 = somaQuadrado1 / ultimos1.size();
      desvio1    = sqrt(variancia);
      maximo1    = max1;
      minimo1    = min1;
      Vpp1       = valorpp1;
      
      tsEstatistico1 = millis();
      }
   }
}
// Classe para desenhar graficos

class Grafico {                                                                    
  int x, y;
  int corLinha;
  String titulo;
  int largura = 910, altura = 360;
  String tensaoPT   = "Tensão (V)";
  String tensaoEN   = "Voltage (V)";
  String correntePT = "Corrente (mA)";
  String correnteEN = "Current (mA)";
  String ohm        = "Ohms (Ω)";
  String fasePT     = "Fase (º)";
  String faseEN     = "Phase (º)";


  Grafico(int x, int y, int corLinha, String titulo) {
    this.x = x;
    this.y = y;
    this.corLinha = corLinha;
    this.titulo = titulo;
  }

  // Método genérico para desenhar qualquer gráfico
  void desenharFundo(int[] valoresY, String eixoYTexto) {
    // Fundo
    stroke(55);
    strokeWeight(5);
    fill(1);
    rect(x, y, largura, altura, 5);

    // Linha central (y=0)
    stroke(255, 255, 255, 20);
    strokeWeight(1);
    line(x + 10, y + altura/2, x + largura - 10, y + altura/2);

    // Linhas horizontais e rótulos do eixo Y
    for (int i = 0; i < valoresY.length; i++) {
      int valor = valoresY[i];
      float py = map(valor, valoresY[0], valoresY[valoresY.length-1], y + altura - 10, y + 10);

      stroke(255, 255, 255, 70);
      line(x + largura/13 - 5, py, x + largura - 10, py); // linha horizontal
      fill(255);
      textAlign(RIGHT, CENTER);
      text(nf(valor, 1), x + largura/13 - 10, py);
    }

    // Eixo X
    fill(255);
    textAlign(CENTER, TOP);
    text("Tempo (s)", x + largura - 45, y + altura + 7);

    // Eixo Y
    pushMatrix();
    translate(x - 40, y + altura / 2);
    rotate(-HALF_PI);
    textAlign(CENTER, TOP);
    text(eixoYTexto, 20, 50);
    popMatrix();

    // Divisões por segundo
    int taxaamostragem = 50;
    int segundostotais = coletor.maxPontos / taxaamostragem;
    for (int s = 0; s <= segundostotais; s++) {
      float px = map(s * taxaamostragem, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
      stroke(255, 255, 255, 70);
      line(px, y, px, y + altura);
    }

    // Título do gráfico
    fill(255);
    textAlign(CENTER, TOP);
    text(titulo, x + largura / 2, y + 10);
  }
  
  void desenharFundoV() {
    String label = idioma.equals("PT") ? tensaoPT : tensaoEN;
    desenharFundo(new int[]{-2, -1, 0, 1, 2}, label);
  }

  void desenharFundoA() {
    String label = idioma.equals("PT") ? correntePT : correnteEN;
    desenharFundo(new int[]{-2, -1, 0, 1, 2}, label);
  }

  void desenharFundo_Real() {
    desenharFundo(new int[]{-450, -225, 0, 225, 450}, ohm);
  }

  void desenharFundo_Ima() {
    desenharFundo(new int[]{-60, -30, 0, 30, 60}, ohm);
  }

  void desenharFundo_Ampli() {
    desenharFundo(new int[]{-450, -225, 0, 225, 450}, ohm);
  }

  void desenharFundo_fase() {
    String label = idioma.equals("PT") ? fasePT : faseEN;
    desenharFundo(new int[]{-8, -4, 0, 4, 8}, label);
  }


  void desenharDados (ArrayList<Float> dados, float minY, float maxY, int corLinha) {
       stroke(corLinha);
       strokeWeight(2);
       noFill();
       beginShape();
       for (int i = 0; i < dados.size(); i++) {
           float px = map(i, 0, coletor.maxPontos, x + largura/13, x + largura - 10);
           float py = map(dados.get(i), minY, maxY, y + altura - 10, y + 10);
           vertex(px, py);
    }
    endShape();
  }
  
    void desenharDadosSimulados (float[] dados, float minY, float maxY, int corLinha) {
       stroke(corLinha);
       strokeWeight(2);
       noFill();
       beginShape();
       for (int i = 0; i < dados.length; i++) {
           float px = map(i, 0, dados.length -1, x + largura/13, x + largura - 10);
           float py = map(dados[i], minY, maxY, y + altura - 10, y + 10);
           vertex(px, py);
    }
    endShape();
  }
  
 }  
     
// ***** Classe estatisticas ***** //
class Estatistica {
  
  String mediaPT     = "Média (x̅):" ;
  String mediaEN     = "Average (x̅): "; 
  String desvioPT    = "Desvio Padrão (s): ";
  String desvioEN    = "Standard Deviation (s): "; 
  String varianciaPT = "Variância (s²): "; 
  String varianciaEN = "Variance (s²): ";
  String maximoPT    = "Máximo: ";
  String maximoEN    = "Maximum: ";
  String minimoPT    = "Minimo: ";
  String minimoEN    = "Minimum: ";
  String VPP         = "VPP: ";
  String tituloPT    = "Indicadores Estatísticos";
  String tituloEN    = "Statistical Indicators";
  
  String txtMedia()     { return idioma.equals("PT") ? mediaPT     : mediaEN; }
  String txtDesvio()    { return idioma.equals("PT") ? desvioPT    : desvioEN; }
  String txtVariancia() { return idioma.equals("PT") ? varianciaPT : varianciaEN; }
  String txtMaximo()    { return idioma.equals("PT") ? maximoPT    : maximoEN; }
  String txtMinimo()    { return idioma.equals("PT") ? minimoPT    : minimoEN; }
  String txtTitulo()    { return idioma.equals("PT") ? tituloPT    : tituloEN; }
  
  void desenhar(float media, float desvio, 
                float variancia, float maximo, float minimo, float Vpp, float media1, float desvio1, float variancia1, float maximo1, float minimo1, float Vpp1) {
    
    int x = 1000, y = 500;
    stroke(55);
    strokeWeight(2);
    fill(1);
    rect(x +120, 165, 260, 360, 5);

    fill(255);
    textAlign(CENTER, TOP);
    text(txtTitulo(), x + 470 / 2, y - 300);

    textAlign(LEFT, TOP);
    int margem = x + 120;
    int linha  = y -250;
    int esp    = 40;
    text(txtMedia()      + nf(media, 1, 3),     margem +10, linha);
    text(txtDesvio()     + nf(desvio, 1, 3),    margem +10, linha + esp);
    text(txtVariancia()  + nf(variancia, 1, 3), margem +10, linha + esp * 2);
    text(txtMaximo()     + nf(maximo, 1, 3),    margem +10, linha + esp * 3);
    text(txtMinimo()     + nf(minimo, 1, 3),    margem +10, linha + esp * 4);
    text(VPP             + nf(Vpp),             margem +10, linha + esp * 5);
    
    int x1 = 1000, y1 = 500;
    stroke(55);
    strokeWeight(2);
    fill(1);
    rect(x +120, 550, 260, 360, 5);

    fill(255);
    textAlign(CENTER, TOP);
    text(txtTitulo(), x + 470 / 2, y + 80);

    textAlign(LEFT, TOP);
    int margem1 = x1 + 120;
    int linha1  = y1 -250;
    int esp1    = 40;
    text(txtMedia()      + nf(media1, 1, 3),     margem1 +10, linha1 + 380);
    text(txtDesvio()     + nf(desvio1, 1, 3),    margem1 +10, linha1 + esp + 380);
    text(txtVariancia()  + nf(variancia1, 1, 3), margem1 +10, linha1 + esp  * 2 + 380);
    text(txtMaximo()     + nf(maximo1, 1, 3),    margem1 +10, linha1 + esp1 * 3 + 380);
    text(txtMinimo()     + nf(minimo1, 1, 3),    margem1 +10, linha1 + esp1 * 4 + 380);
    text(VPP             + nf(Vpp1),             margem1 +10, linha1 + esp1 * 5 + 380);
  }
}

// ***** Classe Botão ***** //
class Botao {
  int x, y, w, h; //Atributo da posição
  String texto; //Atributo texto
  int corNormal, corHover, corAtivo, corParado, corVoltar; //Atributo cor
  boolean pressionado        = false;
  boolean iniciarPressionado = false;
  boolean Ativo              = false;
  boolean Parado             = false;
  
  Botao(int x, int y, int w, int h, String texto, int corNormal, int corHover) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.texto     = texto;
    this.corNormal = corNormal;
    this.corHover  = corHover;
    this.corAtivo  = color(20, 180, 70);
    this.corParado = color(200, 70, 70);
    this.corVoltar = color(255,222,33);
  }
  
  //Método desenha o botão da na tela e muda a cor se o mouse estiver sobre ele
  void desenhar() {                                                                   
    
    if (Ativo) {
       fill(corAtivo);       // COR FIXA quando selecionado
    }
    else if (Parado) {
       fill(corParado);
    }
    else if (estaSobre(mouseX, mouseY)) {
            fill(corHover);       // hover normal
    }
    else {
       fill(corNormal);      // estado normal
    }
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

static class Simulador {
  
  static int idx = 0;

  // Buffers dinâmicos que crescem como no modo real
  static ArrayList<Float> tensao   = new ArrayList<Float>();
  static ArrayList<Float> corrente = new ArrayList<Float>();
  static ArrayList<Float> polar    = new ArrayList<Float>();
  static ArrayList<Float> fase     = new ArrayList<Float>();
  static ArrayList<Float> real     = new ArrayList<Float>();
  static ArrayList<Float> imag     = new ArrayList<Float>();
  
  static int maxPontosSimulado = 900;

  
  static float[] tensaosimulado   = {
    1.00, 0.97, 0.94, 0.91, 0.88, 0.86, 0.83, 0.80, 0.77, 0.74, 0.71, 0.68, 0.65, 0.62, 0.59,
    0.57, 0.54, 0.51, 0.48, 0.45, 0.42, 0.39, 0.36, 0.33, 0.30, 0.28, 0.25, 0.22, 0.19, 0.16,
    0.13, 0.10, 0.07, 0.04, 0.01, -0.01, -0.04, -0.07, -0.10, -0.13, -0.16, -0.19, -0.22, -0.25, -0.28,
   -0.30, -0.33, -0.36, -0.39, -0.42, -0.45, -0.48, -0.51, -0.54, -0.57,
   -0.59, -0.62, -0.65, -0.68, -0.71, -0.74, -0.77, -0.80, -0.83, -0.86, -0.88, -0.91, -0.94, -0.97, -1.00};
    
  static float[] correntesimulado = {
    1.00, 0.97, 0.94, 0.91, 0.88, 0.86, 0.83, 0.80, 0.77, 0.74, 0.71, 0.68, 0.65, 0.62, 0.59, 0.57, 0.54, 0.51, 0.48, 0.45,
    0.42, 0.39, 0.36, 0.33, 0.30, 0.28, 0.25, 0.22, 0.19, 0.16, 0.13, 0.10, 0.07, 0.04, 0.01, -0.01, -0.04, -0.07, -0.10, -0.13,
   -0.16, -0.19, -0.22, -0.25, -0.28, -0.30, -0.33, -0.36, -0.39, -0.42, -0.45, -0.48, -0.51, -0.54, -0.57,
   -0.59, -0.62, -0.65, -0.68, -0.71, -0.74, -0.77, -0.80, -0.83, -0.86, -0.88, -0.91, -0.94, -0.97, -1.00};
  
  static float [] polarsimulado = {
    1.00, 0.97, 0.94, 0.91, 0.88, 0.86, 0.83, 0.80, 0.77, 0.74, 0.71, 0.68, 0.65, 0.62, 0.59, 0.57, 0.54, 0.51, 0.48, 0.45,
    0.42, 0.39, 0.36, 0.33, 0.30, 0.28, 0.25, 0.22, 0.19, 0.16, 0.13, 0.10, 0.07, 0.04, 0.01, -0.01, -0.04, -0.07, -0.10, -0.13,
   -0.16, -0.19, -0.22, -0.25, -0.28, -0.30, -0.33, -0.36, -0.39, -0.42, -0.45, -0.48, -0.51, -0.54, -0.57,
   -0.59, -0.62, -0.65, -0.68, -0.71, -0.74, -0.77, -0.80, -0.83, -0.86, -0.88, -0.91, -0.94, -0.97, -1.00};
  
  static float[] fasesimulado = {
  5.85, 5.82, 6.23, 5.78, 5.78, 5.91, 6.10, 6.41, 6.12, 5.97, 5.88, 6.26, 5.85, 6.30, 6.42, 6.15, 5.94, 6.02, 6.58, 5.96,
  6.42, 5.88, 6.05, 5.69, 5.78, 5.84, 6.54, 6.16, 6.23, 6.33, 6.09, 6.07, 6.25, 6.29, 6.66, 6.55, 5.70, 6.40, 6.02, 6.56,
  5.96, 6.37, 5.78, 6.11, 6.07, 5.93, 5.84, 6.03, 6.25, 5.93, 6.23, 5.76, 5.75, 6.16, 5.65, 6.12, 6.13, 6.20, 5.86, 5.94,
  6.35, 6.05, 5.76, 6.10, 5.73, 6.29, 6.48, 6.28, 6.19, 6.53};
 
  static float[] realsimulado = {
    387.35, 380.16, 380.44, 384.22, 384.06, 380.91, 382.13, 384.14, 379.64, 381.84, 382.46, 381.16, 382.89, 382.45, 384.20, 385.14, 382.26, 382.39, 381.16, 379.27,
    380.93, 379.28, 384.08, 383.45, 380.88, 381.90, 380.90, 383.53, 379.59, 381.70, 384.09, 383.30, 380.35, 383.41, 380.79, 381.35, 381.07, 379.88, 382.82, 383.17,
    383.70, 381.71, 380.91, 382.58, 381.96, 382.96, 382.68, 383.09, 380.80, 378.68, 382.38, 382.02, 381.72, 383.22, 381.75, 382.53, 380.54, 383.37, 381.60, 384.48,
    382.81, 382.45, 380.05, 379.98, 382.93, 385.51, 382.34, 382.32, 383.45, 380.61};
  
  static float[] imaginsimulado = {
  39.67, 38.73, 41.55, 38.92, 38.88, 39.41, 40.82, 43.13, 40.70, 39.91, 39.36, 41.80, 39.21, 42.20, 43.26, 41.53, 39.80, 40.34, 43.97, 39.59,
  42.88, 39.07, 40.71, 38.19, 38.54, 39.05, 43.67, 41.40, 41.42, 42.33, 40.97, 40.75, 41.66, 42.24, 44.48, 43.80, 38.05, 42.63, 40.35, 44.09,
  40.03, 42.63, 38.53, 40.98, 40.60, 39.75, 39.12, 40.45, 41.69, 39.34, 41.71, 38.51, 38.46, 41.35, 37.75, 41.02, 40.90, 41.67, 39.15, 40.03,
  42.63, 40.55, 38.36, 40.63, 38.41, 42.52, 43.41, 42.05, 41.57, 43.56};
  
 // --- ENTREGAR 1 AMOSTRA POR VEZ ---
  static void atualizar() {

    // Inserir valores 1 a 1 (como ocorre via serial)
    tensao.add(tensaosimulado[idx]);
    corrente.add(correntesimulado[idx]);
    polar.add(polarsimulado[idx]);
    fase.add(fasesimulado[idx]);
    real.add(realsimulado[idx]);
    imag.add(imaginsimulado[idx]);

    // Limitar tamanho dos arrays
    if (tensao.size() > maxPontosSimulado) {
      tensao.remove(0);
      corrente.remove(0);
      polar.remove(0);
      fase.remove(0);
      real.remove(0);
      imag.remove(0);
    }

    // Avançar índice
    idx = (idx + 1) % tensaosimulado.length;
  }

  // --- MÉTODOS PARA OS GRÁFICOS ---
  static ArrayList<Float> getTensao()   { return tensao; }
  static ArrayList<Float> getCorrente() { return corrente; }
  static ArrayList<Float> getPolar()    { return polar; }
  static ArrayList<Float> getFase()     { return fase; }
  static ArrayList<Float> getReal()     { return real; }
  static ArrayList<Float> getImag()     { return imag; }

}


// ***** Classe coletor serial ***** //
class ColetorSerial {
  Serial porta; //Atributo - canal de comunjicação
  ArrayList<Float> dadosY  = new ArrayList<Float>();                                                   
  ArrayList<Float> dadosY1 = new ArrayList<Float>();                                                   
  ArrayList<Float> dadosY2 = new ArrayList<Float>();                                                  
  ArrayList<Float> dadosY3 = new ArrayList<Float>();                                                   
  ArrayList<Float> dadosY4 = new ArrayList<Float>();                                 
  ArrayList<Float> dadosY5 = new ArrayList<Float>();                                                   
  
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
          if (partes.length == 6) {
            float Y  = float(partes[0]);
            float Y1 = float(partes[1]);
            float Y2 = float(partes[2]);
            float Y3 = float(partes[3]);
            float Y4 = float(partes[4]);
            float Y5 = float(partes[5]);

            dadosY.add(Y);
            dadosY1.add(Y1);
            dadosY2.add(Y2);
            dadosY3.add(Y3);
            dadosY4.add(Y4);
            dadosY5.add(Y5);

            if (dadosY.size()  > maxPontos) dadosY.remove(0);                                        //Dados da componente real
            if (dadosY1.size() > maxPontos) dadosY1.remove(0);                                       // Dados da componente imaginária
            if (dadosY2.size() > maxPontos) dadosY2.remove(0);                                       // Senoide 1
            if (dadosY3.size() > maxPontos) dadosY3.remove(0);                                       // Senoide 2
            if (dadosY4.size() > maxPontos) dadosY4.remove(0);                                       // Senoide 2
            if (dadosY5.size() > maxPontos) dadosY5.remove(0);                                       // Senoide 2
    }
      } catch (Exception e) {
        println("Erro ao converter valor: " + linha);
      }
    }
  }
}
