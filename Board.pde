class Board {
    float x, y, w, h; // bounding rectangle
    Tile[][] grid;
    HashMap<String, ScoredSequence> bestScore;
  
    Board(String boardCharsPassed) {
        /* dimensions in designated area of window */
        x = .1*bWidth; y = .1*bHeight;
        w = .8*bWidth; h = .8*bHeight;
        
        /* make the tiles and set up neighbor relations */
        grid = new Tile[4][4];
        for(int i=0; i<4; i++) 
            for(int j=0; j<4; j++) 
                grid[i][j] = new Tile(j, i, coordsOf(j, i), boardCharsPassed.charAt(4*i+j));
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
            ScoredSequence old = bestScore.get(wordSoFar);
            if(old == null || seq.findScore() > old.score) {
                bestScore.put(wordSoFar, new ScoredSequence(seq));    
            }
        }
        
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
