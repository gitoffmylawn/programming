class Solution:
    def longestCommonPrefix(self, strs: list[str]) -> str:
        prefix = strs[0]
        del strs[0]
        for i in strs:
            o = list(prefix)
            t = list(i)
            for k in range(len(o)):
                try:
                    if o[k] != t[k]:
                        prefix = o[:k:]
                        break
                except IndexError:
                    prefix = o[:k:]
                    break
        return "".join(prefix)

sol = Solution()
prefix = sol.longestCommonPrefix(["flower","flow","flight"])
print(prefix)
prefix2 = sol.longestCommonPrefix(["","b"])
print(prefix2)
