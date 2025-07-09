import processing.sound.*;

//Crear la variable de sonido.
SoundFile miCancion;
//Crear variable amplitud
Amplitude miAmp;

//Crear variable de Onda
Waveform miOnda;
Waveform miOnda02;
int numMuestras=30;
int numMuestras2 = 360;

//Variable velocidad
int velocidad =5;
float rx = 400;

Sound s;


void setup() 
{
  size(800, 800);
  frameRate(60);
  
  //Importar cancion
  miCancion = new SoundFile(this, "Cancion.mp3");

  //Inicio la cancion.
  miCancion.play();

  //Calcula amplitud
  miAmp = new Amplitude(this);
  miAmp.input(miCancion);
  
  //Iniciamos la Onda
  miOnda = new Waveform(this, numMuestras);
  miOnda.input(miCancion);
  
  miOnda02 = new Waveform(this, numMuestras2);
  miOnda02.input(miCancion);
  
  // Create a Sound object for globally controlling the output volume.
  s = new Sound(this);
  
  rectMode(CENTER);
}

void draw() 
{  
  //Esta variabale es la que me da el valor de la apmlitud
  float amplitud = miAmp.analyze();
  
  //El color del fondo va a cambiar con la musica
  float col = map(amplitud,0,1,1,255);
  
  background(col,200,200);
  noStroke();
  
  //Dibuja las barras de sonido
  // Barras de abajo
  fill(#E08309);
  float alto = amplitud * 100;
  for (int i = 0; i < 10; i++) {
      rect(40+i * 80, 800 - alto / (i % 3 + 1), 40, 400);
  }
  
  
  
  //Dibujar el rectangulo de la mitad
  //Se mueve con las ondas
  miOnda.analyze();
  for (int i=0; i<numMuestras; i=i+1) {
    noStroke();
    fill(#E08309);
    float dato=miOnda.data[i];
    float tamR = map(dato, 0, 1, 0, 30);
    pushMatrix();
    translate(400, 400);
    rotate(radians(tamR));
    rect(0,0,500,10);
    popMatrix();
  }

  
  //Dibujar circulo
  miOnda02.analyze();
  for (int i=0; i<numMuestras2; i=i+1) 
  {
    noStroke();
    fill(#E08309);
    float dato=miOnda02.data[i];
    float tamR = map(dato, 0, 1, 0, 3);
    pushMatrix();
    translate(400, 0);
    rotate(radians(i));
    rect(0,0,400,tamR);
    popMatrix();
  }

  
  // Controla el volumen con la posición del mouse
  // Map vertical mouse position to volume.
  // Instead of setting the volume for every oscillator individually, we can just
  // control the overall output volume of the whole Sound library.
  // tomado de processing.org/sound
  float vol = map(mouseY, 0, height, 1, 0.0);
  s.volume(vol);
  
  //Pinta un triangulo que sigue las coordenadas del mouse
  //Si el mouse está entre 0 y 400, el triangulo es hacia arriba
  //Sie el mouse está entre 400 y 800, el triangulo es hacia abajo
  stroke(#343434);
  strokeWeight(4);
  noFill();
  float tam = 30;
  if(mouseY<=400)
  {
    beginShape();
    vertex(mouseX,mouseY-tam);
    vertex(mouseX+tam/2,mouseY);
    vertex(mouseX-tam/2,mouseY);
    endShape(CLOSE);
  }
  else
  {
    beginShape();
    vertex(mouseX,mouseY+tam);
    vertex(mouseX+tam/2,mouseY);
    vertex(mouseX-tam/2,mouseY);
    endShape(CLOSE);
  }

}

//Aqui se hace la función para pausar o reanudar la musica
//Cada vez que se hace click se hace play o se pausa
void mousePressed()
{
  if(miCancion.isPlaying())
  {
    miCancion.pause();
  }
  else
  {
    miCancion.play();
  }
}
