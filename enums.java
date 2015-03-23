enum TileChar {
    
}

enum Bonus {
    DOUBLE_LETTER("DL",2,1), 
    TRIPLE_LETTER("TL",3,1),
    DOUBLE_WORD("DW",1,2), 
    TRIPLE_WORD("TW",1,3),
    NONE("n",1,1);
    
    private final String disp;
    private final int letterMult, wordMult;
    Bonus(String disp, int lm, int wm) {
        this.disp = disp;
        letterMult = lm; wordMult = wm; 
    }    
    
    String getDisp() {
        return disp;
    }
    
    int getLM() {
        return letterMult;
    }
    
    int getWM() {
        return wordMult;
    }
    
    static Bonus byDisp(String other) {
        for(Bonus b : Bonus.values()) {
            if(other.equals(b.getDisp())) return b;
        }
        
        return null;
    }
}
