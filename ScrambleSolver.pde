
import java.util.HashSet;
import java.util.Map;

char[][] boardChars = {{'w','a','i','n'},
                      {'p','l','n','t'},
                      {'i','a','s','a'},
                      {'y','f','t','r'}};

char[] letters = {'a','b','c','d','e','f','g','h','i','j','k',
'l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

HashMap<Character, Integer> pointsByLetter;

Board board;
WordDisplay wordDisplay;

String[] words; /* Array of all the dictionary words, in alphabetical order */

Prefix root;
int numPrefixes = 0;

int bHeight = 400; /* dimensions of the */
int bWidth = 400; /*       BOARD       */

void setup() {
    size(600,400);
	
    board = new Board(boardChars);
	wordDisplay = new WordDisplay();
	
	/* setting some constants based on which dict I'm using;
		right now I'm sticking to the _OrLess dicts */
	int[] dictSizeByMaxWordLen = new int[]{0,0,0,1066,4965,13595,28817,51922,80339,105212,125512,141016};
	int maxWordLen = 11;
	String fileName = "dict" + maxWordLen + "OrLess.txt";
	int dictSize = dictSizeByMaxWordLen[maxWordLen];
	
	/* Setting up dictionary; and timing */
	{int dictStart = millis();
	words = new String[dictSize]; // was 170491
    setupDict(fileName);
	int dictEnd = millis();
	println("time for dict", dictEnd - dictStart);}
    
	/* Setting up Prefixes; and timing */
	{int preStart = millis();
	root = new Prefix(0,dictSize-1,"");
	println("numPrefixes=", numPrefixes);
	int preEnd = millis();
	println("time for Pres", preEnd - preStart);}
	
	/* running Board.consider() on each tile in the grid 
		ie find all words that start with that tile */
	{for(int i=0; i<4; i++)
		for(int j=0; j<4; j++) 
			board.consider(new Sequence(new Tile[]{board.grid[i][j]}));}
		
	HashMap<String, ScoredSequence> bestScore = board.bestScore; // pointless shortcut name
	StringList wordList = new StringList();
	
	/* put all the found words into a sorted StringList */
	{for(String key : bestScore.keySet()) {
		wordList.append(key);
	}
	wordList.sort();}
	
	/* write the sorted StringList to file "boardsamplefound.txt" */
	PrintWriter output = createWriter("boardsamplefoundSorted.txt");
	for(String word : wordList) {
		output.println(word);
	}
	output.flush();
	output.close();
	
	println();	
	int numWords = bestScore.keySet().size();
	println(numWords); 
	
	println(bestScore.get("lips")==null);
	 
}

void draw() {
    board.display();
	wordDisplay.display();
}


void setupDict(String fileName) {
	BufferedReader reader;
	String line;

	reader = createReader(fileName);
	
    int n=0;
    
    try {
        while((line=reader.readLine()) != null) {
            words[n] = line;
            n++;
        }
    } catch (IOException e) {
        e.printStackTrace();
    }
	
	int[] points = {1, 4, 4, 2, 1, 4, 3, 3, 1, 10, 5, 2, 4, 2, 1, 4, 10, 1, 1, 1, 2, 5, 4, 8, 3, 10};
	pointsByLetter = new HashMap<Character, Integer>();
	
	for(int i=0; i<26; i++) {
		pointsByLetter.put(letters[i], points[i]);
	}
	
}

class ScoredSequence {
	Sequence seq;
	int score;
	
	ScoredSequence(Sequence seq, int score) {
		this.seq = seq;
		this.score = score;
	}
}
	

class Board {
    float x, y, w, h; // bounding rectangle
    Tile[][] grid;
	

	HashMap<String, ScoredSequence> bestScore;
  
    Board(char[][] boardCharsPassed) {
		/* dimensions in designated area of window */
        x = .1*bWidth; y = .1*bHeight;
        w = .8*bWidth; h = .8*bHeight;
        
		/* make the tiles and set up neighbor relations */
        grid = new Tile[4][4];
        for(int i=0; i<4; i++) 
            for(int j=0; j<4; j++) 
                grid[i][j] = new Tile(j, i, coordsOf(j, i), boardCharsPassed[i][j]);
        setupNeighbors();
		
		/* initialize bestScore */
		bestScore = new HashMap<String, ScoredSequence>();
    }
    
    void consider(Sequence seq) {
        if(!seq.isValid()) println("invalid sequence");
		
		String wordSoFar = seq.getWord();
		Prefix pre = root.proceed(wordSoFar);
		if(pre.isWord) {
			/*println("this sequence made the word ", wordSoFar);*/
			bestScore.put(wordSoFar, new ScoredSequence(seq, seq.findScore()));	
		}
		
		
		/*println("about this Prefix: ", "wordSoFar=" + pre.wordSoFar, str(pre.start)+"="+words[pre.start], str(pre.end)+"="+words[pre.end]); */
		
		Tile lastTile = seq.getLast();
		HashSet<Character> nextLetters = new HashSet(pre.longerWords.keySet());
		ArrayList<Tile> nbrsToTry = new ArrayList<Tile>(lastTile.neighbors);
		
		for(int n=nbrsToTry.size()-1; n>=0; n--) {
			Tile tst = nbrsToTry.get(n);
			if(nextLetters.contains(tst.letter) && seq.tiles.indexOf(tst)==-1) {
				//println(tst.col, tst.row, tst.letter);
				ArrayList<Tile> ext_tiles = new ArrayList<Tile>(seq.tiles);
				ext_tiles.add(tst);
				Sequence extension = new Sequence(ext_tiles);
				consider(extension);
			}
		}
		
		
	/*	for(Tile nb : lastTile.neighbors) {
			if(nextLetters.contains(nb.letter) && seq.tiles.indexOf(nb)==-1) {
				println(nb.letter);
			}
		} */ 
/* 		for(char ch : pre.longerWords.keySet()) {
			Prefix ext = pre.longerWords.get(ch);
			println(words[ext.start]);
		} */
    }
        
    
    void setupNeighbors() {
        for(int i=0; i<4; i++) {
            for(int j=0; j<4; j++) {
                grid[i][j].neighbors = findNeighborsOf(i, j);
            }
        } 
    }
    
    ArrayList<Tile> findNeighborsOf(int row, int col) {
        ArrayList neighbors = new ArrayList<Tile>();
        
        boolean top, bottom, left, right;
        top = (row==0);
        bottom = (row==3);
        left = (col==0);
        right = (col==3);
        
        if(!top) neighbors.add(grid[row-1][col]);
        if(!bottom) neighbors.add(grid[row+1][col]);
        if(!left) neighbors.add(grid[row][col-1]);
        if(!right) neighbors.add(grid[row][col+1]);
        
        if(!top & !left) neighbors.add(grid[row-1][col-1]);
        if(!top & !right) neighbors.add(grid[row-1][col+1]);
        if(!bottom & !left) neighbors.add(grid[row+1][col-1]);
        if(!bottom & !right) neighbors.add(grid[row+1][col+1]);

        return neighbors;
    }

    PVector coordsOf(int px, int py) {
        if(!(0<=px && px<=4 && 0<=py && py<=4)) {
            print("error");
            return null;
        } else {
            return new PVector(x + w/8 + px*w/4, y + h/8 + py*h/4);
        }
    }  
  
    void display() {
        fill(255);
        rect(x, y, w, h);
        
        textAlign(CENTER, CENTER);
        textSize(18);
        fill(0);
        for(int i=0; i<4; i++) {
            for(int j=0; j<4; j++) {
                grid[i][j].display();
            }
        }
    }
}

class Tile {
    int row, col;
    PVector location;
    char letter;
    ArrayList<Tile> neighbors;
    
    Tile(int row, int col, PVector location, char letter) {
        this.row = row;
        this.col = col;
        this.location = location;
        this.letter = letter;
    }
    
    void display() {
        float hs = 30;
        float r = 10;
        float x = location.x;
        float y = location.y;
        
        /* curved parts of border */ {
        fill(#FEFF00);
        arc(x-hs+r, y-hs+r, 2*r, 2*r, PI, 3*PI/2);
        arc(x+hs-r, y-hs+r, 2*r, 2*r, 3*PI/2, 2*PI);
        arc(x+hs-r, y+hs-r, 2*r, 2*r, 0, PI/2);
        arc(x-hs+r, y+hs-r, 2*r, 2*r, PI/2, PI);
        }
		
        /* fill rest of inside */ {
        noStroke();
        rect(x-hs, y-hs+r, 2*hs, 2*(hs-r));
        rect(x-hs+r, y-hs, 2*(hs-r), 2*hs);
        }
		
        /* straight parts of border */ {
        stroke(1);
        line(x-hs, y-hs+r, x-hs, y+hs-r);
        line(x+hs, y-hs+r, x+hs, y+hs-r);
        line(x+hs-r, y+hs, x-hs+r, y+hs);
        line(x+hs-r, y-hs, x-hs+r, y-hs);
        }
		
		/* letter and points */ {
        fill(0);
        textSize(20);
		String disp = str(letter);
		disp = disp.toUpperCase();
		if(disp.equals("Q")) disp = "Qu";
        text(disp, location.x, location.y - 3);
        textSize(12);
        text(pointsByLetter.get(letter), location.x + 16, location.y + 16);
		}
    }
        
}

class Sequence {
    ArrayList<Tile> tiles;
    
    Sequence(ArrayList<Tile> tiles) {
        this.tiles = tiles;
    }
	
	Sequence(Tile[] tiles) {
        this.tiles = new ArrayList<Tile>();
		for(int i=0; i<tiles.length; i++) {
			(this.tiles).add(tiles[i]);
		}
    }
    
    boolean isValid() {
        HashSet<Tile> tileSet = new HashSet<Tile>(tiles);
        
        if(tileSet.size() != tiles.size()) return false;
        
        // check for connectedness
        for(int i=0; i<tiles.size()-1; i++) {
            if(!tiles.get(i).neighbors.contains(tiles.get(i+1))) {
                return false;
            }
        }
        return true;    
    }
    
    int findScore() {
        int score = 0;
		
		if(!this.isValid()) {
			println("invalid sequence");
		} else {
			if(tiles.size()==2) return 1;
			
			for(Tile t : tiles) {
				score += pointsByLetter.get(t.letter);
			}        
		}
		return score;
    }
    
    String getWord() {
        String word = "";
        for(int i=0; i < tiles.size(); i++) {
			String disp = str(tiles.get(i).letter);
			if(disp.equals("q")) disp = "qu";
            word = word + disp;
        }
        return word;
    }
    
    void drawSelf() {
        for(int i=0; i < tiles.size()-1; i++) {
            arrow(tiles.get(i).location, tiles.get(i+1).location);    
        }
    }
    
	Tile getLast() {
		int n = tiles.size();
		return tiles.get(n-1);
	}
	
	Sequence extend(Tile newTile) {
		ArrayList<Tile> newTileList = new ArrayList<Tile>(tiles);
		newTileList.add(newTile);
		return new Sequence(newTileList);
	}
}

class Prefix {
    boolean isWord = false;
    String wordSoFar;
    int start, end;
    HashMap<Character, Prefix> longerWords;
    
    Prefix(int start, int end, String wordSoFar) {
        numPrefixes++;
        
        this.start = start;
        this.end = end;
        this.wordSoFar = wordSoFar;
		longerWords = new HashMap<Character, Prefix>();

        String firstWord = words[start];
        String lastWord = words[end];		
        //println(wordSoFar, start, firstWord, end, lastWord);
        
		if(wordSoFar.equals(firstWord)) isWord = true;

        if(wordSoFar.length()<=9) {
            setupLongerWords();
            //println(wordSoFar, start, firstWord, end, lastWord, longerWords.size());
        }
    }
    
    void setupLongerWords() {
        String firstWord = words[start];
        String lastWord = words[end];        
        
        int k = wordSoFar.length()+1;  // k represents the length of any prefix created by this one
          
		int n=start; //index as I go through words
		int lastEnd = start-1; //end of the last prefix made  
		if(wordSoFar.equals(firstWord)) { //this prefix is a word
			n++;
			lastEnd++;
        }
		
        for(char i : letters) {
            while(n<=end && words[n].length()>=k && words[n].charAt(k-1)==i) {
                n++;
            }
            if( n>lastEnd+1 ) {
                String newWord = wordSoFar + i;
                if(newWord.length()==0) return;
                longerWords.put(i, new Prefix(lastEnd+1, n-1, newWord));
                lastEnd = n-1;
            }
        }
    }
    
    Prefix proceed(String nextLetters) {
        Prefix curr = this;
        for(int i=0; i<nextLetters.length(); i++) {
            char ch = nextLetters.charAt(i);
            curr = curr.longerWords.get(ch);
        }
        return curr;
    }
    
	int countExtensions() {
		return longerWords.size();
	}
	
	void printNextLetters() {
		println(longerWords.keySet().toString());
	}
}

class WordDisplay {
	float x, y, w, h; // bounding rectangle
	ArrayList<Sequence> seqsForWords;
	
	WordDisplay() {
		x = bWidth + .1*(width - bWidth);
		y = .1*height;
		w = .8*(width - bWidth);
		h = .8*height;
		seqsForWords = new ArrayList<Sequence>();
	}
	
	void display() {
		fill(255);
        rect(x, y, w, h);
	}
}

void line(PVector p1, PVector p2) {
    line(p1.x, p1.y, p2.x, p2.y);
}

int ord(char ch) {
    return ch - 'a';
}

void arrow(PVector p1, PVector p2) {

    PVector diff, cwise, cowise, mid;
        
    line(p1, p2);
    
    diff = PVector.sub(p1, p2);
    diff.setMag(12);
    mid = PVector.add(p1, p2);
    mid.mult(.5);
    
    cwise = new PVector(diff.x, diff.y);
    cwise.rotate(-PI/6);
    cwise.add(mid);
    
    cowise = new PVector(diff.x, diff.y);
    cowise.rotate(PI/6);
    cowise.add(mid);    
    
    line(mid, cwise);
    line(mid, cowise);
}
