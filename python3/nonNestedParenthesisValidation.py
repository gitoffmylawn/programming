class Solution:
    def isValid(self, s: str) -> bool:
        keys = {
            "(": ")",
            "[": "]",
            "{": "}"
        }
        for i in range(0, len(s), 2):
            if s[i+1] != keys[s[i]]:
                return False
        return True

sol = Solution()
binary = sol.isValid("()")
print(binary)
binary2 = sol.isValid("(){)][")
print(binary)
binary3 = sol.isValid("(){}[]")
print(binary3)
