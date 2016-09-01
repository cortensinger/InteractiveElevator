import processing.serial.*;

PFont f;
PImage eric, kevin, chris;
int num = 0;
int press = 1;
int up = 1;
int vib = 1;
int left = 1;
boolean use = false;
int useTime = 0;
int floor = 0;
int bg1;
int bg2;
int bg3;
int fgcolor;           // Fill color
int fg;
int light;
int flex;
int floor1;
int floor2;
int floor3;
int knob;
int button;
int count = 0;
int face = 0;
Serial myPort;                       // The serial port
int[] serialInArray = new int[10];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ypos;                 // Starting position of the ball
boolean firstContact = false;        // Whether we've heard from the microcontroller

void setup() {
  f = loadFont("Bauhaus93-48.vlw");
  eric = loadImage("eric.png");
  kevin = loadImage("kevin.jpg");
  chris = loadImage("chris.jpg");
  size(780, 780);  // Stage size
  noStroke();      // No border on the next thing drawn

  // Set the starting position of the ball (middle of the stage)
  xpos = width/2;
  ypos = height/2;

  // Print a list of the serial ports for debugging purposes
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  if (use) {
    useTime = useTime + 1;
  }
  if (useTime > 800) {
    use = false;
    useTime = 0;
    floor = 0;
  }
  if (!use) {
    background(0, 0, 0);
    textFont(f);
    fill(22, 104, 266);
    text("Please Select A Floor", width/2 - 200, height/2);
  } else if (fg == 0) {
    background(bg1 + light, bg2 + light, bg3 + light);
  }
  
  count = count + 1; 

  if ((floor1 != 0) && !use) {
    use = true;
    floor = 1;
  } else if ((floor2 != 0) && !use) {
    use = true;
    floor = 2;
  } else if ((floor3 != 0) && !use) {
    use = true;
    floor = 3;
  }
  
  if (floor == 1) {
    textFont(f);
    fill(200);
    text("Floor 1", ypos, xpos);
    rotate(button);
  } else if (floor == 2) {
    textFont(f, 40);
    fill(40);
    text("Floor 2", ypos, xpos);
    rotate(button);
  } else if (floor == 3) {
    background(10 + light, 80 + light, 100 + light);
    textFont(f, 40);
    fill(120);
    text("Floor 3", ypos, xpos);
    
    if (button != 0) {
      face = face + 1;
      if (face > 60) {
        face = -2;
      }
    }
    
    if ((face > 0) && (face < 20)) {
      image(eric, 100, 100);
    } else if ((face > 20) && (face < 40)) {
      image(kevin, 400, 100);
    } else if ((face > 40) && (face < 60)) {
      image(chris, 100, 300);
    }
    
    num = num + 1;
    if (press == 69) {
      up = 0;
    }
    if (vib == 8) {
      left = 0;
    }
    if (press == -60) {
      up = 1;
    }
    if (vib == -8) {
      left = 1;
    }
    if (up == 1) {
      press = press + 1;
    } else {
      press = press - 1;
    }
    if (left == 1) {
      vib = vib + 1;
    } else {
      vib = vib - 1;
    }
    stroke(15, 180, 100);
    fill(255, 255, 255);
    ellipse(xpos, ypos, 200, 180);
    ellipse(xpos + 250, ypos, 200, 180);
    if (fg != 0) {
      fill((num * 2) % 255, (num % 255) / 2, 100);
    } else {
      fill((xpos + ypos)/2, xpos, 180);
    }
    ellipse(xpos, ypos, 140, 140);
    ellipse(xpos + 250, ypos, 140, 140);
    fill(160, 210, 230);
    rect(xpos + 100, ypos, 10, 180);
    rect(xpos + 100, ypos + 180, 100, 10);
    fill(0, 0, 0);
    if (fg != 0) {
      ellipse(xpos, ypos, 70 + press, 70 + press);
      ellipse(xpos + 250, ypos, 70 + press, 70 + press);
    } else {
      ellipse(xpos, ypos, 70, 70);
      ellipse(xpos + 250, ypos, 70, 70);
    }
    fill(255, 255, 255);
    if (fg != 0) {
      ellipse(xpos + 25 + vib*2, ypos - 25 + vib*2, 26, 26);
      ellipse(xpos - 33 - vib*3, ypos + 10, 10, 10);
      ellipse(xpos - 25, ypos + 23 - vib*3, 10, 10);
      ellipse(xpos + 275 + vib*2, ypos - 25 + vib*2, 26, 26);
      ellipse(xpos + 217 - vib*3, ypos + 10, 10, 10);
      ellipse(xpos + 225, ypos + 23 - vib*3, 10, 10);
    } else {
      ellipse(xpos + 25, ypos - 25, 26, 26);
      ellipse(xpos - 33, ypos + 10, 10, 10);
      ellipse(xpos - 25, ypos + 23, 10, 10);
      ellipse(xpos + 275, ypos - 25, 26, 26);
      ellipse(xpos + 217, ypos + 10, 10, 10);
      ellipse(xpos + 225, ypos + 23, 10, 10);
    }
  }

  if (use && floor != 3) {
    fill(fgcolor);
    ellipse(xpos, ypos, 40, 40 + flex - 194);
    fill(22, 104, 266);
    ellipse((count/1.5)%700, (count/1.5)%700, 30 + knob + flex - 194, 30 + knob);
    fill(13, 125, 50);
    rect((count-2)%700, ((count/1.5) + 30)%700, 15 + knob + flex -194, 15 + knob);
    fill(198, 144, 18);
    rect((count + count/2)%700, 180, 1 + knob + flex - 194, count % 50);
    fill(145, 6, 188);
    ellipse(580, (count - 2)%700, 20 + knob, 20 + flex - 194);
    ellipse(200, (count - 2)%700, 20 + knob, 20 + flex - 194);
    ellipse((count - 2)%700, (count - 2)%700, 20 + knob, 20 + flex - 250);
  }
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller.
  // Otherwise, add the incoming byte to the array:
  if (firstContact == false) {
    if (inByte == 'A') {
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  }
  else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;
    println(serialCount);
    // If we have 3 bytes:
    if (serialCount > 9 ) {
      xpos = serialInArray[0]*3;
      ypos = serialInArray[1]*3;
      fg = serialInArray[2];
      light = serialInArray[3];
      flex = serialInArray[4];
      floor1 = serialInArray[5];
      floor2 = serialInArray[6];
      floor3 = serialInArray[7];
      knob = serialInArray[9]*3;
      button = serialInArray[8] / 255;
      bg1 = 240;
      bg2 = (xpos/2)%255;
      bg3 = (xpos + ypos)/2;

      // print the values (for debugging purposes only):
      println(floor1 + "\t" + floor2 + "\t" + floor3 + "\t" + fg);

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}