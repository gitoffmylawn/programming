class Solution:
    def isValid(self, s: str) -> bool:
        while True:
            if "()" in s:
                s = s.replace("()","")
            elif "{}" in s:
                s = s.replace("{}","")
            elif "[]" in s:
                s = s.replace("[]","")
            else:
                return False
            if len(s) == 0:
                return True

sol = Solution()
binary = sol.isValid("()")
print(binary)
sol2 = Solution()
binary2 = sol2.isValid("(){)][")
print(binary2)
binary3 = sol.isValid("(){}[]")
print(binary3)
