class Solution:
    def isPalindrome(self, x: int) -> bool:
        r = str(x)[::-1]
        return str(x) == r
