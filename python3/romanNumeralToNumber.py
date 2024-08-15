class Solution:
    def romanToInt(self, s: str) -> int:
        count, numeral = self.exceptions(s)
        return count + self.roman(numeral)

    def exceptions(self, s: str) -> tuple[int, str]:
        exceptions = { "IV": 4, "IX": 9, "XL": 40, "XC": 90, "CD": 400, "CM": 900 }
        total = 0
        numeral = s
        for x,y in exceptions.items():
            if x in s:
                total = y + total
                numeral = numeral.replace(x,"")
        return total, numeral

    def roman(self, s: str) -> int:
        romans = { "I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000 }
        count = 0
        for l in s:
            count = count + romans[l]
        return count

sol = Solution()
count = sol.romanToInt("MMXXII")
print(count)
