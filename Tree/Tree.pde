import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
//AudioPlayer song;
AudioInput song;
FFT fft;
 float theta;  
void setup()
{
  size(900, 800);
 
  minim = new Minim(this);
 
  song = minim.getLineIn(Minim.STEREO,2048,22000);
 
  //song = minim.loadFile("mysong.mp3", 512);
  //song.play();
 
  fft = new FFT(song.bufferSize(), song.sampleRate());

}
 
void draw()
{
  background(0);
  fft.forward(song.mix);
    for(int i = 0; i < fft.specSize(); i++)
  {
    stroke(255,55,0);//wave
    line(i, height, i, height - fft.getBand(i)*2);
    double v = fft.getBand(i);
      println(v);
     
  }
  
    for(int i = 0; i < song.bufferSize() - 1; i++)
  {
    stroke(12,255,12);//manyline
    line(i, 150 + song.left.get(i)*50, i+1, 150 + song.left.get(i+1)*50);
    line(200 + song.left.get(i)*50, i, 200 + song.left.get(i+1)*50, i+1);
    line(i, 450 + song.right.get(i)*50, i+1, 450 + song.right.get(i+1)*50);
        line(600 + song.right.get(i)*50, i, 600 + song.right.get(i+1)*50, i+1);
  }
  
  stroke(255,20,140);//tree
  strokeWeight(3);
  frameRate(60);
  for(int i = 0; i < fft.specSize(); i++)
  {
        
        // Let's pick an angle 0 to 90 degrees based on the mouse position
        float a = fft.getBand(i) * 90f*2;
        theta = radians(a);
        println(theta);
  }
      // Convert it to radians
      
      // Start the tree from the bottom of the screen
      translate(width/2,height);
      // Draw a line 120 pixels
      line(0,0,0,-120);
      // Move to the end of that line
      translate(0,-120);
      // Start the recursive branching!
      branch(120);

  for(int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);
    line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*50);
  }

}

void branch(float h) {
  // Each branch will be 2/3rds the size of the previous one
  h *= 0.66;
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  }
}
