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
            int len = tiles.size();
            if(len==2) return 1;
            
            if(len>=4) score = (len-3)*(len-2)/2;
            
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
