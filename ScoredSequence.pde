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
