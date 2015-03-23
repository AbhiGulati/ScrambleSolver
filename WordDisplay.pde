class WordDisplay {
    float x, y, w, h; // bounding rectangle
    ArrayList<ScoredWord> foundWords;
    int firstShown = 0;
    int fontSize = 20; 
    float verticalGap = 4.0;
    float horizontalMargin = 40;
    int selectedIndex = -1; int maxWords;
    
    WordDisplay(float x, float y, float w, float h) {
        this.x = x; this.y = y;
        this.w = w; this.h = h;
        
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
            
            fill(0); textAlign(LEFT, TOP);
            text(word, x+horizontalMargin, y);
            textAlign(RIGHT, TOP);
            text(score, x+w-horizontalMargin, y);
        }
    }
    
    void display() {
        fill(255);
        rect(x, y, w, h); 
        
        if(foundWords.size()==0) return;
        if(selectedIndex<0) selectedIndex=0;
        
        fill(0);
        textSize(fontSize); 
        
        maxWords = int(h / (fontSize+4));
        float sx = x + 4, sy = y + 4;
        for(int i=firstShown; i<min(foundWords.size(), firstShown+maxWords); i++) {
            ScoredWord sw = foundWords.get(i);
            sw.display(sy, i==selectedIndex);
            
            sy += fontSize + verticalGap;
        }
        
        if(selectedIndex >= 0) 
            foundWords.get(selectedIndex).seq.drawSelf();

    }
    
    void addWord(ScoredSequence newSeq) {
        foundWords.add(new ScoredWord(newSeq));
    }
    
    void stepUp() {
        if(selectedIndex>0 & selectedIndex--==firstShown) 
                firstShown--;
    }
    
    void stepDown() {
        if(selectedIndex+1 < foundWords.size() & ++selectedIndex == firstShown+maxWords) 
            firstShown = selectedIndex;   
    }    

}
