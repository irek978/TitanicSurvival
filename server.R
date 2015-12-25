library(sqldf)
library(shiny)

shinyServer(
    
    function(input,output) {
        
        dfTitanic<-data.frame(Titanic)
        
        titanicage<-sqldf('select distinct 
                          Class,
                          Sex,
                          Age,
                          (case when Age = "Child" then 0 else 17 end) as MinAge,
                          (case when Age = "Child" then 16 else 100 end) as MaxAge,
                          Survived,
                          freq
                          from dfTitanic')
        
        titanictot<-sqldf('select distinct 
                          Class,
                          Sex,
                          Age,
                          MinAge,
                          MaxAge,
                          "All" as Survived,
                          Sum(Freq) as Freq from titanicage
                          group by Class,Sex,Age,MinAge,MaxAge')
        
        titanicsurv<-sqldf('select distinct * from titanicage where survived = "Yes"')
        titanicnotsurv<-sqldf('select distinct * from titanicage where survived = "No"')
        
        titanicperc<-sqldf('select distinct a.*, 
                            b.Freq as NrSurvived, 
                            b.Freq/a.Freq as IncSurvived, 
                            c.Freq as NrNotSurvived, 
                            c.Freq/a.Freq as IncNotSurvived
                            from titanictot a left join titanicsurv b  on a.Class=b.Class 
                            and a.Sex=b.Sex 
                            and a.Age=b.Age
                            left join titanicnotsurv c on a.Class=c.Class
                            and a.Sex=c.Sex 
                            and a.Age=c.Age
                            where b.Freq <> 0
                            group by a.Class,a.Sex,a.Age,a.MinAge,a.MaxAge
                           ')
        
        
        
        filter <- function(df, Class, Sex, Age) {
            All<-"All"
            dfClass<-data.frame(Class)
            names(dfClass)<-c('x')
            dfSex<-data.frame(Sex)
            names(dfSex)<-c('x')
            dfAge<-data.frame(merge(Age,All))
            names(dfAge)<-c('x','y')
            
            dffilter<-sqldf('select distinct * from df a 
                    inner join dfClass b on a.Class=b.x
                    inner join dfSex c on a.Sex=c.x
                    left join dfAge d on a.Survived=d.y
                    where d.x >=a.MinAge and d.x <=a.MaxAge')
            
            resultnoformat<-dffilter$IncSurvived
                
            resultperc<-paste(round(100*resultnoformat,2), "%", sep="")
            resultperc
            
            
            resultctrl<-if (resultperc >0) {resultperc}
            else {
                "NA"
            }
            
            resultctrl
        }
        
        
        output$inputAgeValue<-renderText({input$age})
        output$inputSexValue<-renderText({input$sex})
        output$inputClassValue<-renderText({input$class})
        
        prediction<-reactive({
            filter(titanicperc,input$class,input$sex,input$age)
        })
        
        output$prediction<-renderText({prediction()})
    }
)