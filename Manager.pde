class Manager {
    Board board;
    WordDisplay wordDisplay;
    FindAllButton findButton;
    ClearButton clearButton;
    
    Manager() {
        wordDisplay = new WordDisplay(360, 20, 220, 320);
        clearButton = new ClearButton(380, 400, 180, 80); 
        
        board = new Board(boardChars, 20, 20, 320, 320, wordDisplay);
        findButton = new FindAllButton(70, 380, 220, 100);
    }    
    
    void display() {
        board.display();
        wordDisplay.display();
        findButton.display();
        clearButton.display();
    }
    
    void handleClick() { 
        if(wordDisplay.isEmpty()) {
            findButton.handleClick();
            board.handleClick();
        } else {
            clearButton.handleClick();
        }
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
    
    class ClearButton {
        float x, y, w, h;
        
        ClearButton(float x, float y, float w, float h) {
            this.x = x; this.y = y;
            this.w = w; this.h = h;
        }
        
        void display() {
            fill(255);
            rect(x, y, w, h);
            fill(0); textAlign(CENTER, CENTER); textSize(36);
            text("Clear", x+w/2, y+h/2 -4);
        }
        
        void handleClick() {
            if( x<=mouseX & mouseX<=x+w  &  y<=mouseY & mouseY<=y+h ) {
                wordDisplay.clear();
            }
        }
    }
}
