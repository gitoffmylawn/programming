class Solution {
    public boolean isPalindrome(int x) {
        System.out.println(String.valueOf(x));
        return String.valueOf(x) == reverse(String.valueOf(x));
    }

    public String reverse(String s) {
        String r = "";
        for (int i = 0; i < s.length(); i++) {
            r = s.charAt(i) + r;
        }
        return r;
    }
}
