class WordDisplay {
    float x, y, w, h; // bounding rectangle
    ArrayList<ScoredWord> foundWords;
    int firstShown = 0;
    int fontSize = 20; 
    float verticalGap = 4.0;
    float horizontalMargin = 4;
    int selectedIndex = 0; int maxWords;
    
    WordDisplay() {
        x = bWidth + .1*(width - bWidth); y = .1*height;
        w = .8*(width - bWidth); h = .8*height;
        
        foundWords = new ArrayList<ScoredWord>();
    }
    
    class ScoredWord {
        Sequence seq;
        String word;
        int score;
        
        ScoredWord(ScoredSequence ss) { //note doesn't ensure it's a word
            this.seq = ss.seq;
            word = ss.wordSoFar;
            score = ss.score;
        }
        
        void display(float y, boolean selected) {
            if(selected) {
                fill(#07F548);
                rect(x+2, y, w-4, fontSize+3);
            }
            
            fill(0);
            textAlign(LEFT, TOP);
            text(word, x+horizontalMargin, y);
            textAlign(RIGHT, TOP);
            text(score, x+w-horizontalMargin, y);
        }
    }
    
    void display() {
        fill(255);
        rect(x, y, w, h); 
        
        fill(0);
        textSize(fontSize); 
        
        maxWords = int(h / (fontSize+4));
        float sx = x + 4;
        float sy = y + 4;
        for(int i=firstShown; i<min(foundWords.size(), firstShown+maxWords); i++) {
            ScoredWord sw = foundWords.get(i);
            sw.display(sy, i==selectedIndex);
            
            sy += fontSize + verticalGap;
        }
        
        if(selectedIndex >= 0) {
            ScoredWord sw = foundWords.get(selectedIndex);
            sw.seq.drawSelf();
        }
    }
    
    void addWord(ScoredSequence newSeq) {
        foundWords.add(new ScoredWord(newSeq));
    }
    
    void stepUp() {
        if(selectedIndex>0) {
            if(selectedIndex==firstShown) {
                firstShown--;
            }
            selectedIndex--;
        }    
    }
    
    void stepDown() {
        if(selectedIndex+1 < foundWords.size()) {
            if(selectedIndex+1 == firstShown+maxWords) {
                firstShown = selectedIndex+1;
            }    
            
            selectedIndex++;
        }
    }
    
    void shiftDown() {
        firstShown++; //this needs to change     
    }
    
    void shiftUp() {
        firstShown = max(firstShown-1, 0);
    }
}
