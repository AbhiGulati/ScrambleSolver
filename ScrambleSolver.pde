import java.util.HashSet;
import java.util.Map;
import java.util.Arrays;
import java.util.Comparator;

String boardChars = "potuknareiteclsw"; 
char[] letters = {'a','b','c','d','e','f','g','h','i','j','k',
'l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};
HashMap<Character, Integer> pointsByLetter;

String[] words; /* Array of all the dictionary words, in alphabetical order */
Prefix root;
int numPrefixes = 0;

Manager manager;

void setup() {
    size(600,500);
    
    /* setting some constants based on which dict I'm using;
        still I'm sticking to the _OrLess dicts */
    int[] dictSizeByMaxWordLen = new int[]{0,0,0,1066,4965,13595,28817,51922,80339,105212,125512,141016};
    int maxWordLen = 10;
    String fileName = "dict" + maxWordLen + "OrLess.txt";
    int dictSize = dictSizeByMaxWordLen[maxWordLen];
    
    /* Setting up dictionary*/
    words = new String[dictSize];
    setupDict(fileName);
    /* Setting up Prefixes */
    root = new Prefix(0,dictSize-1,"");
    
    
    manager = new Manager();
     
}

void draw() {
    manager.display();
}

void keyPressed() {
    if(key == CODED) {
        if(keyCode == DOWN) {
            manager.wordDisplay.stepDown();
        } else if(keyCode == UP) {
            manager.wordDisplay.stepUp();
        }
    }
}

void mousePressed() {
    println("mouseX="+mouseX, "mouseY="+mouseY);
    manager.handleClick();
}
