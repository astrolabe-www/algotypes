import processing.serial.*; 

Serial myPort; 
byte[] inByte;
int nBytes = 4;
boolean readyForBytes = false;

byte[] outBuffer = new byte[4096];
int outBufferCount = 0;

void setup() { 
  size(400, 200);  
  printArray(Serial.list());  
  myPort = new Serial(this, Serial.list()[3], 115200);
  myPort.clear();
} 


void draw() {
  if (outBufferCount >= outBuffer.length) {
    saveBytes("frames.raw", outBuffer);
    exit();
  }
}

void serialEvent(Serial myPort) {
  if (myPort.available() < nBytes) return;

  if (readyForBytes) {
    byte[] readBuf = new byte[nBytes];
    int bytesRead = myPort.readBytes(readBuf);
    println("read " + bytesRead + " bytes");
    if (bytesRead == nBytes) {
      arraycopy(readBuf, 0, outBuffer, outBufferCount, min(nBytes, outBuffer.length - outBufferCount));
      outBufferCount += min(nBytes, outBuffer.length - outBufferCount);
    }
    //println(readBuf);
    readyForBytes = false;
    nBytes = 4;
  } else {
    inByte = myPort.readBytes(1);
    if (inByte[0] == (byte)0xDE) {
      inByte = myPort.readBytes(1);
      if (inByte[0] == (byte)0xAD) {
        inByte = myPort.readBytes(1);
        nBytes = (inByte[0] & 0xff) << 8;
        inByte = myPort.readBytes(1);
        nBytes |= (inByte[0] & 0xff);
        println("buf size: " + nBytes);
        readyForBytes = true;
      }
    }
  }
}
