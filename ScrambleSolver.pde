import java.util.HashSet;
import java.util.Map;
import java.util.Arrays;
import java.util.Comparator;

String boardChars = "abacttusttttttttt"; 

/* Word length bonuses: 
7 -> 10, 6 -> 6, 5 -> 3 */

char[] letters = {'a','b','c','d','e','f','g','h','i','j','k',
'l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

HashMap<Character, Integer> pointsByLetter;

Board board;
WordDisplay wordDisplay;

String[] words; /* Array of all the dictionary words, in alphabetical order */

Prefix root;
int numPrefixes = 0;

int bHeight = 400;
int bWidth = 400; 

void setup() {
    size(600,400);
    
    board = new Board(boardChars);
    wordDisplay = new WordDisplay();
    
    /* setting some constants based on which dict I'm using;
        right now I'm sticking to the _OrLess dicts */
    int[] dictSizeByMaxWordLen = new int[]{0,0,0,1066,4965,13595,28817,51922,80339,105212,125512,141016};
    int maxWordLen = 10;
    String fileName = "dict" + maxWordLen + "OrLess.txt";
    int dictSize = dictSizeByMaxWordLen[maxWordLen];
    
    /* Setting up dictionary*/
    words = new String[dictSize];
    setupDict(fileName);
    
    /* Setting up Prefixes */
    root = new Prefix(0,dictSize-1,"");
    
    /* running Board.consider() on each tile in the grid 
        ie find all words that start with that tile */
    for(int i=0; i<4; i++)
        for(int j=0; j<4; j++) 
            board.consider(new Sequence(new Tile[]{board.grid[i][j]}));
        
    HashMap<String, ScoredSequence> bestScore = board.bestScore; // just a shortcut name
    ScoredSequence[] bestScoreArray = new ScoredSequence[bestScore.keySet().size()];
    
    {
        int i=0;
        for(String word : bestScore.keySet()) {
            bestScoreArray[i] = bestScore.get(word);
            i++;
        }
    }
    
    Arrays.sort(bestScoreArray, new SSComparator());
    int totalPossiblePoints = 0;
    for(int i=0; i<bestScoreArray.length; i++) {
        ScoredSequence ss = bestScoreArray[i];
        println(ss.score, ss.wordSoFar);
        totalPossiblePoints += ss.score;
        wordDisplay.addWord(ss);
    }
    println("possible points", totalPossiblePoints);
    
    int numWords = bestScore.keySet().size();
    println("number of words found = ", numWords); 
     
}

void draw() {
    board.display();
    wordDisplay.display();
}

void keyPressed() {
    if(key == CODED) {
        if(keyCode == DOWN) {
            wordDisplay.stepDown();
        } else if(keyCode == UP) {
            wordDisplay.stepUp();
        }
    }
}

void mousePressed() {
    println("firstShown",wordDisplay.firstShown, "selectedIndex",wordDisplay.selectedIndex,"maxWords", wordDisplay.maxWords);
}
