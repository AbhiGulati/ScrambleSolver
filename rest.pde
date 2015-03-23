class SSComparator implements Comparator<ScoredSequence> {
    int compare(ScoredSequence a, ScoredSequence b) {
        return b.score - a.score;
    }
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

