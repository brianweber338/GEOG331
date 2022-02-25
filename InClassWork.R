flower <- iris[iris$Species=="virginica"]

#lm(y ~ x)
fit <- l(flower$Petal.length ~ flower$Sepal.length)

summary(fit)

plot(flower$Sepal.Length, summary(fit)$residuals,
     xlab = "Sepal length", ylab = "residuals", )

hist(summary(fit)$residuals)

shapiro.test(summary(fit)$residuals)