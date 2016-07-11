import processing.video.*;
import processing.serial.*;
import ddf.minim.*;

/**
  * Sons 
  */
Minim som;
AudioPlayer gravacao;
float duracaoSom = 0;
float milis = 0;

/**
  * Flags
  */
boolean isSound = false;
boolean isPlay = false;
boolean inicial = true;

Serial minhaPorta;       
String stringValue;  
float floatValue;
int numProcesso = 10;

int numMovies = 7;
Movie[] playlist = new Movie[numMovies];
int movieIndex = 0;
  
void setup(){
  minhaPorta = new Serial(this, Serial.list()[32], 9600);
  minhaPorta.bufferUntil('\n');
  printArray(Serial.list());
  
  size(1200, 800);
  frameRate(24);
  background(0);
  
  som = new Minim(this);
  getSoundNoDelay("sons/relax.mp3");
  
  for(int i = 0 ; i < numMovies; i++){
    if(i == 0){
      playlist[i] = new Movie(this,"videos/Inicial.mp4");
    }
    else{  
      playlist[i] = new Movie(this, "videos/video"+(i)+".mp4");
    }
  }
  playlist[movieIndex].loop();
}

void draw() {
 background(0);
 thread("requestData");
 image(playlist[movieIndex], 0, 0, width, height);
}

void movieEvent(Movie m) {
  
  if(floatValue > 900 && inicial == true){
    m.read();
  }
  else{
    inicial = false;
    isSound = true;
  }
  
  if(isSound){
    switch(numProcesso){
      case 1 : {
        movieIndex = 1;
        getSoundNoDelay("sons/1_apresentacao_pt1.mp3", m);
        break;
      }
      /**
        * Aqui já começam as perguntas
        */
      case 2 : {
        movieIndex = 2;
        getSoundNoDelay("sons/2_bens_materiais_perg.mp3", m);
        break;
      }
      case 3 : {
        getResposta(1, m);
        break;
      }
      case 4 : {
        movieIndex = 3;
        getSoundNoDelay("sons/3_familia_perg.mp3", m);
        break;
      }
      case 5 : {
        getResposta(2, m);
        break;
      }
      case 6 : {
        movieIndex = 4;
        getSoundNoDelay("sons/4_deus_perg.mp3", m);
        break;
      }
      case 7 : {
        getResposta(3, m);
        break;
      }
      case 8 : {
        movieIndex = 5;
        getSoundNoDelay("sons/5_dor_perg.mp3", m);
        break;
      }
      case 9 : {
        getResposta(4, m);
        break;
      }
      case 10 : {
        movieIndex = 6;
        getSoundNoDelay("sons/6_morte_perg.mp3", m);
        break;
      }
      case 11 : {
        getResposta(5, m);
        break;
      }
    }
  }
  
}

public void getSound(String somFile){
    AudioPlayer audio = som.loadFile(somFile);
    int duracao = (int) audio.length();
    audio.play();
    delay(duracao);
}

public void getSoundNoDelay(String somFile){
    som.loadFile(somFile).play();
}

public void getSoundNoDelay(String somFile, Movie m){
    
    if(!isPlay){
      gravacao = som.loadFile(somFile);
      playlist[movieIndex].play();
      duracaoSom = millis() + gravacao.length();
      gravacao.play();
    }
    isPlay = true;
    
    m.read();
    
    if(millis() > duracaoSom){
      println("TERMINOU");
      numProcesso++;
      isPlay = false;
    }
}

public void getResposta(int pergunta, Movie m){
    String somFile = "";
    if(!isPlay){
      /**
        * Os IFs averiguam qual o valor da resistência
        */
      if(floatValue >= 1000){
        getSound("sons/nao.mp3");
        /**
          * O switch averigua qual o valor da pergunta
          */
        switch(pergunta){
          case 1: {
            somFile = "sons/2_bens_materiais_resp_nao.mp3";
            break;
          }
          case 2: {
            somFile = "sons/3_familia_resp_nao.mp3";
            break;
          }
          case 3: {
            somFile = "sons/4_deus_resp_nao.mp3";
            break;
          }
          case 4: {
            somFile = "sons/5_dor_resp_nao.mp3";
            break;
          }
          case 5: {
            somFile = "sons/tiro.mp3";
            break;
          }
        }
      }
      else if(floatValue >= 800 && floatValue < 1000){
        getSound("sons/talvez.mp3");
        /**
          * O switch averigua qual o valor da pergunta
          */
        switch(pergunta){
          case 1: {
            somFile = "sons/2_bens_materiais_resp_talvez.mp3";
            break;
          }
          case 2: {
            somFile = "sons/3_familia_resp_talvez.mp3";
            break;
          }
          case 3: {
            somFile = "sons/4_deus_resp_talvez.mp3";
            break;
          }
          case 4: {
            somFile = "sons/5_dor_resp_talvez.mp3";
            break;
          }
          case 5: {
            somFile = "sons/tiro.mp3";
            break;
          }
        }
      }
      else {
        getSound("sons/sim.mp3");
        /**
          * O switch averigua qual o valor da pergunta
          */
        switch(pergunta){
          case 1: {
            somFile = "sons/2_bens_materiais_resp_sim.mp3";
            break;
          }
          case 2: {
            somFile = "sons/3_familia_resp_sim.mp3";
            break;
          }
          case 3: {
            somFile = "sons/4_deus_resp_sim.mp3";
            break;
          }
          case 4: {
            somFile = "sons/5_dor_resp_sim.mp3";
            break;
          }
          case 5: {
            somFile = "sons/tiro.mp3";
            break;
          }
        }
      }
      gravacao = som.loadFile(somFile);
      playlist[movieIndex].play();
      duracaoSom = millis() + gravacao.length();
      gravacao.play();
    }
    isPlay = true;
    
    m.read();
    
    if(millis() > duracaoSom){
      println("TERMINOU");
      numProcesso++;
      isPlay = false;
    }
}

/**
  * Thread
  */
public void requestData() {
  while(minhaPorta.available() > 0 ) {
    stringValue = minhaPorta.readStringUntil('\n');
    floatValue = Float.parseFloat(stringValue);
    println("Float: " + floatValue);
  }
}