class Manager {
    Board board;
    WordDisplay wordDisplay;
    FindAllButton button;
    
    Manager() {
        wordDisplay = new WordDisplay(360, 20, 220, 320);
        board = new Board(boardChars, 20, 20, 320, 320, wordDisplay);
        button = new FindAllButton(70, 380, 220, 100);
        //board.findAllWords();
        //board.setupWordDisplay();
    
    }    
    
    void display() {
        board.display();
        wordDisplay.display();
        button.display();
    }
    
    void handleClick() { 
        button.handleClick();
        board.handleClick();
    }
    
    class FindAllButton {
        float x, y, w, h;
        
        FindAllButton(float x, float y, float w, float h) {
            this.x = x; this.y = y;
            this.w = w; this.h = h;
        }
        
        void display() {
            fill(255);
            rect(x, y, w, h);
            fill(0); textAlign(CENTER, CENTER); textSize(36);
            text("Search", x+w/2, y+h/2 -4);
        }
        
        void handleClick() {
            if( x<=mouseX & mouseX<=x+w  &  y<=mouseY & mouseY<=y+h ) {
                board.findAllWords();
                board.setupWordDisplay();
            }
        }
    }
}
