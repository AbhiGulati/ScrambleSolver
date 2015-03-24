/* A Prefix represents the chunk of (consecutive) words in the dictionary starting with the given string of letters (wordSoFar) */
class Prefix {
    boolean isWord = false;
    String wordSoFar;
    int start, end;
    HashMap<Character, Prefix> longerWords;
    
    Prefix(int start, int end, String wordSoFar) {
        numPrefixes++;
        
        this.start = start; this.end = end;
        this.wordSoFar = wordSoFar;
        longerWords = new HashMap<Character, Prefix>();

        String firstWord = words[start];
        String lastWord = words[end];        
        
        if(wordSoFar.equals(firstWord)) isWord = true;

        if(wordSoFar.length()<=9) {
            setupLongerWords();
        }
    }
    
    void setupLongerWords() {
        String firstWord = words[start];
        String lastWord = words[end];                
        int k = wordSoFar.length()+1;  // k represents the length of any prefix created by this one
        
        int n=start; //index as I go through words
        int lastEnd = start-1; //end of the last prefix made  
        if(wordSoFar.equals(firstWord)) { //this prefix is a word
            n++;
            lastEnd++;
        }
        
        for(char i : letters) { 
            while(n<=end && words[n].length()>=k && words[n].charAt(k-1)==i) 
                n++; 
            
            if(n > lastEnd+1) {
                String newWord = wordSoFar + i;
                if(newWord.length()==0) {println("wtf"); return;}
                longerWords.put(i, new Prefix(lastEnd+1, n-1, newWord));
                lastEnd = n-1;
            }
        }
    }
    
    /* nextLetters to wordSoFar to obtain a new Prefix */
    Prefix proceed(String nextLetters) {
        Prefix curr = this;
        for(int i=0; i<nextLetters.length(); i++) {
            char ch = nextLetters.charAt(i);
            curr = curr.longerWords.get(ch);
        }
        return curr;
    }
    
    int countExtensions() {
        return longerWords.size();
    }
    
    void printNextLetters() {
        println(longerWords.keySet().toString());
    }
}
