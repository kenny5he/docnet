#### 属性复制:
参考文档: https://blog.csdn.net/zhige_me/article/details/80699784
1. 转换类
    ```
        @Mapper(componentModel="spring")
        public interface PersonConverter {
            @Mappings({
                @Mapping(source = "birthday", target = "birth"),
                @Mapping(source = "birthday", target = "birthDateFormat", dateFormat = "yyyy-MM-dd HH:mm:ss"),
                @Mapping(target = "birthExpressionFormat", expression = "java(org.apache.commons.lang3.time.DateFormatUtils.format(person.getBirthday(),\"yyyy-MM-dd HH:mm:ss\"))"),
                @Mapping(source = "user.age", target = "age"),
                @Mapping(target = "email", ignore = true)
            })
            PersonDTO domain2dto(Person person);
        
            List<PersonDTO> domain2dto(List<Person> people);
        }
    ```
2. 调用
    1. 原生调用
        ```
            Mappers.getMapper(PersonConverter.class).domain2dto(person);
        ```
    2. Spring结合调用
        ```
        @Autowired
        private PersonConverter personConverter;
       
        personConverter.domain2dto(person);
       ```

3. maven
    ```
    <properties>
        <org.mapstruct.version>1.3.0.Final</org.mapstruct.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.mapstruct</groupId>
            <artifactId>mapstruct</artifactId>
            <version>${org.mapstruct.version}</version>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.5.1</version> <!-- or newer version -->
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                    <annotationProcessorPaths>
                        <path>
                            <groupId>org.mapstruct</groupId>
                            <artifactId>mapstruct-processor</artifactId>
                            <version>${org.mapstruct.version}</version>
                        </path>
                        <!-- other annotation processors -->
                    </annotationProcessorPaths>
                </configuration>
            </plugin>
        </plugins>
    </build>
    ```