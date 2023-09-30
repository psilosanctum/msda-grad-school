# This is the file we will use for Data Types in Module 2

v1 = c(1,2,3,4,5,6,7,8,9,10)
print(v1)
class(v1)
length(v1) # dim() will not work here with vectors, use for < 1-dim objects 

v2 = c(1:10)
print(v2)
class(v2)
length(v2)

f1 = c(FALSE, TRUE, TRUE, FALSE, TRUE)
f2 = c(F, T, T, F, T)
print(f1)
print(f2)
class(f1)
class(f2)

class(letters)
class(LETTERS)

c1 = c("Hello", "World!")
print(c1)
c2 = paste("Hello", "World!")
print(c2)

c3 = paste("extra", "terrestrial!", sep = "")
print(c3)
c4 = paste0("extra", "terrestrial!")
print(c4)

f3 = factor(c("male", "female", "male", "female", "male", "female", "male", "female", "male", "female"))
class(f3)
print(f3)
levels(f3)

of1 = factor(c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))
plot(table(of1))
of1 = factor(of1, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"), ordered = T)

a1 = c(1,2,3,4)
class(a1)
a1 = c(a1, "a", "b", "c", "d")
print(a1)
class(a1)

a2 = c(1,2,3,4)
class(a2)
sum(a2)

print(v1)
v1[c(4,5,6,7,8)]
v1[-c(5:7)]

f3[-4]
print(f3)

v1[v1<5 & v1 > 7]

c(1:10)
seq(from = 1, length.out = 50, by = 2)

rep(c(1:3), each = 4)
c(rep(c("over", "and"), times = 3), "over")

rep(seq(from = 1, to = 3, by = 0.5), times = 4)  

m1 = matrix(c(1,2,3,4,5,6), nrow = 2, ncol = 3, byrow = T)
print(m1)

m2 = t(m1)
print(m2)

m1 = matrix(c(1:15), nrow = 5)
print(m1)
m1[c(2:4),2]

dim(m1)
length(m1)
m1[m1<6]

ar1 = array(c(1:20), dim = c(5,2,2))
print(ar1)

d1 = c(1:10)
d2 = letters[1:10]
d3 = rep(c(T, F), times = 5)
d4 = factor(c(91:100))

m3 = matrix(c(d1,d2,d3,d4), nrow = 10)
print(m3)
class(m3[,3])

df1 = data.frame(numbers = d1, alphabet = d2, YesNo = d3, facts = d4)
print(df1)

sum(df1[,1])
sum(df1$numbers)

class(df1$alphabet)
print(df1$alphabet)

df2 = data.frame(numbers = d1, alphabet = d2, YesNo = d3, facts = d4, stringsAsFactors = F)
class(df2$alphabet)
print(df2)

class(df2[5,4])
class(df2[[2]])

head(df2, n=3)      
tail(df2, n=4)
summary(df2$alphabet)
str(df2)

lst1 = list(a = c(1:10), b = matrix(c(1:20), nrow = 4), c = df2, d = letters)
print(lst1[[2]])
class(lst1[[2]])

empt1 = logical()
print(empt1)
class(empt1)

mat1 = matrix(c(1:15), nrow = 5)
print(mat1)
class(mat1)
df3 = as.data.frame(mat1)
print(df3)
class(df3)

numb = as.numeric(f1)
print(numb)
class(numb)
logi = as.logical(numb)
print(logi)


mss1 = c(3, NA, 8, 9, 5)
is.na(mss1)
anyNA(mss1)

print(df2)
df2[5,1] = NA
print(df2)
is.na(df2)
anyNA(df2)

df4 = na.omit(df2)
print(df4)
