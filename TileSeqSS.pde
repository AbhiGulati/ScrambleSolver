class Tile {
    private final static float hMargin = 5, vMargin = 3;
    private final static float hs = 30, r = 10;
    int row, col;
    PVector location;
    char letter;
    int letterPoints;
    Bonus myBonus; color c;
    ArrayList<Tile> neighbors;
    
    
    Tile(int row, int col, PVector location, char letter, Bonus bonus) {
        this.row = row; this.col = col;
        this.location = location;
        this.letter = letter; myBonus = bonus;
        this.letterPoints = pointsByLetter.get(letter)*myBonus.getLM();
        pickColor();
    }
    
    void refresh() {
        this.letterPoints = pointsByLetter.get(letter)*myBonus.getLM();
        pickColor();
    }
    
    void handleClick() {
        float x = location.x, y = location.y;
        if( x-hs<=mouseX & mouseX<=x+hs & y-hs<=mouseY & mouseY<=y+hs ) {
            println(row, col, letter);
        }
    }
    
    void pickColor() { /* pick color based on bonus */
        if("DL".equals(myBonus.getDisp())) c = #FFB2E0; 
        else if("DW".equals(myBonus.getDisp())) c = #6FFFED;
        else if("TL".equals(myBonus.getDisp())) c = #6AFF6F;
        else if("TW".equals(myBonus.getDisp())) c = #F6FF00;
        else c = #FFFFFF;
    }
    
    void display() {
        float x = location.x, y = location.y;
        fill(c);
        
        /* curved parts of border */ 
        arc(x-hs+r, y-hs+r, 2*r, 2*r, PI, 3*PI/2);
        arc(x+hs-r, y-hs+r, 2*r, 2*r, 3*PI/2, 2*PI);
        arc(x+hs-r, y+hs-r, 2*r, 2*r, 0, PI/2);
        arc(x-hs+r, y+hs-r, 2*r, 2*r, PI/2, PI);
        
        
        /* fill rest of inside */ 
        noStroke();
        rect(x-hs, y-hs+r, 2*hs, 2*(hs-r));
        rect(x-hs+r, y-hs, 2*(hs-r), 2*hs);
        
        
        /* straight parts of border */ 
        stroke(1);
        line(x-hs, y-hs+r, x-hs, y+hs-r);
        line(x+hs, y-hs+r, x+hs, y+hs-r);
        line(x+hs-r, y+hs, x-hs+r, y+hs);
        line(x+hs-r, y-hs, x-hs+r, y-hs);
        
        
        /* letter and points */ 
        fill(0);
        textSize(20);
        String disp = str(letter);
        disp = disp.toUpperCase();
        //if(disp.equals("Q")) disp = "Qu"; copout
        textAlign(CENTER, CENTER);
        text(disp, x, y-2);
        textSize(12); textAlign(RIGHT, BOTTOM);
        text(pointsByLetter.get(letter), x+hs-hMargin, y+hs-vMargin);
        textSize(12); textAlign(LEFT, BOTTOM);
        text(myBonus.getDisp(), x-hs+hMargin, y+hs-vMargin);
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
        int score = 0, totalMult = 1;
        
        int len = tiles.size();
        
        for(Tile t : tiles) {
            score += t.letterPoints;
            totalMult *= t.myBonus.getWM();
        }

        score *= totalMult;
        if(len>=4) score += (len-3)*(len-2)/2;

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
        PVector start = tiles.get(0).location, end = tiles.get(tiles.size()-1).location;
        noFill();
        strokeWeight(4);
        stroke(#FF8400); ellipse(start.x, start.y, 30, 30); 
        /*this should be done elsewhere */ stroke(0); strokeWeight(1);
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

class ScoredSequence {
    Sequence seq;
    int score;
    String wordSoFar;
    
    ScoredSequence(Sequence seq) {
        this.seq = seq;
        
        score = seq.findScore();
        wordSoFar = seq.getWord();
    }
}
