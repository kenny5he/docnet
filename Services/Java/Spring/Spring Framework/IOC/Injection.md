
### 注入元数据
#### InjectionPoint (注入点)
1. 使用场景信息
    1. Class Filed (注入到字段中)
    ```
    @Inject
    private UserService userService;
    ```
    2. Method Parameter (注入到方法参数中)
    ```
    @Bean
	public ServletRegistrationBean<WebServlet> servelt(@UserService userService) {
      ...
    }
    ```
2. 源码信息如下
```
package org.springframework.beans.factory;


public class InjectionPoint {

    // 包装函数参数时用于保存所包装的函数参数，内含该参数的注解信息
	@Nullable
	protected MethodParameter methodParameter;

    // 包装成员属性时用于保存所包装的成员属性
	@Nullable
	protected Field field;

    // 包装成员属性时用于保存所包装的成员属性的注解信息
	@Nullable
	private volatile Annotation[] fieldAnnotations;


	/**
	 * Create an injection point descriptor for a method or constructor parameter.
     * 构造函数，用于包装一个函数参数
	 * @param methodParameter the MethodParameter to wrap
	 */
	public InjectionPoint(MethodParameter methodParameter) {
		Assert.notNull(methodParameter, "MethodParameter must not be null");
		this.methodParameter = methodParameter;
	}

	/**
	 * Create an injection point descriptor for a field.
     * 构造函数，用于包装一个成员属性
	 * @param field the field to wrap
	 */
	public InjectionPoint(Field field) {
		Assert.notNull(field, "Field must not be null");
		this.field = field;
	}

	/**
	 * Copy constructor.
     * 复制构造函数
	 * @param original the original descriptor to create a copy from
	 */
	protected InjectionPoint(InjectionPoint original) {
		this.methodParameter = (original.methodParameter != null ?
				new MethodParameter(original.methodParameter) : null);
		this.field = original.field;
		this.fieldAnnotations = original.fieldAnnotations;
	}

	/**
	 * Just available for serialization purposes in subclasses.
     * 缺省构造函数，出于子类序列化目的
	 */
	protected InjectionPoint() {
	}


	/**
	 * Return the wrapped MethodParameter, if any.
     * 返回所包装的函数参数，仅在当前对象用于包装函数参数时返回非null
	 * Note: Either MethodParameter or Field is available.
	 * @return the MethodParameter, or null if none
	 */
	@Nullable
	public MethodParameter getMethodParameter() {
		return this.methodParameter;
	}

	/**
	 * Return the wrapped Field, if any.
     * 返回所包装的成员属性，仅在当前对象用于包装成员属性时返回非null
	 * Note: Either MethodParameter or Field is available.
	 * @return the Field, or  null if none
	 */
	@Nullable
	public Field getField() {
		return this.field;
	}

	/**
	 * Return the wrapped MethodParameter, assuming it is present.
     * 获取所包装的函数参数，不会为null，如果当前对象包装的不是函数参数则抛出异常IllegalStateException
	 * @return the MethodParameter (never  null)
	 * @throws IllegalStateException if no MethodParameter is available
	 * @since 5.0
	 */
	protected final MethodParameter obtainMethodParameter() {
		Assert.state(this.methodParameter != null, "Neither Field nor MethodParameter");
		return this.methodParameter;
	}

	/**
	 * Obtain the annotations associated with the wrapped field or method/constructor parameter.
     * 获取所包装的依赖(方法参数或者成员属性)上的注解信息
	 */
	public Annotation[] getAnnotations() {
		if (this.field != null) {
			Annotation[] fieldAnnotations = this.fieldAnnotations;
			if (fieldAnnotations == null) {
				fieldAnnotations = this.field.getAnnotations();
				this.fieldAnnotations = fieldAnnotations;
			}
			return fieldAnnotations;
		}
		else {
			return obtainMethodParameter().getParameterAnnotations();
		}
	}

	/**
	 * Retrieve a field/parameter annotation of the given type, if any.
     * 获取所包装的依赖(方法参数或者成员属性)上的指定类型为annotationType的注解信息，
     * 如果该类型的注解不存在，则返回null
	 * @param annotationType the annotation type to retrieve
	 * @return the annotation instance, or  null if none found
	 * @since 4.3.9
	 */
	@Nullable
	public <A extends Annotation> A getAnnotation(Class<A> annotationType) {
		return (this.field != null ? this.field.getAnnotation(annotationType) :
				obtainMethodParameter().getParameterAnnotation(annotationType));
	}

	/**
	 * Return the type declared by the underlying field or method/constructor parameter,
	 * indicating the injection type.
     * 获取所包装的依赖(方法参数或者成员属性)的类型
	 */
	public Class<?> getDeclaredType() {
		return (this.field != null ? this.field.getType() : 
			obtainMethodParameter().getParameterType());
	}

	/**
	 * Returns the wrapped member, containing the injection point.
     * 1.如果所包装的依赖是成员属性则返回该成员属性，
     * 2.如果所包装的依赖是成员方法参数,则返回对应的成员方法
	 * @return the Field / Method / Constructor as Member
	 */
	public Member getMember() {
		return (this.field != null ? this.field : obtainMethodParameter().getMember());
	}

	/**
	 * Return the wrapped annotated element.
     * 1.如果所包装的依赖是成员属性则返回该成员属性
     * 2.如果所包装的依赖是成员方法参数,则返回对应的成员方法     
     * 可以认为该方法和 getMemer()等价
	 * Note: In case of a method/constructor parameter, this exposes
	 * the annotations declared on the method or constructor itself
	 * (i.e. at the method/constructor level, not at the parameter level).
	 * Use  #getAnnotations() to obtain parameter-level annotations in
	 * such a scenario, transparently with corresponding field annotations.
	 * @return the Field / Method / Constructor as AnnotatedElement
	 */
	public AnnotatedElement getAnnotatedElement() {
		return (this.field != null ? this.field : obtainMethodParameter().getAnnotatedElement());
	}


	@Override
	public boolean equals(Object other) {
		if (this == other) {
			return true;
		}
		if (getClass() != other.getClass()) {
			return false;
		}
		InjectionPoint otherPoint = (InjectionPoint) other;
		return (ObjectUtils.nullSafeEquals(this.field, otherPoint.field) &&
				ObjectUtils.nullSafeEquals(this.methodParameter, otherPoint.methodParameter));
	}

	@Override
	public int hashCode() {
		return (this.field != null ? 
			this.field.hashCode() : 
			ObjectUtils.nullSafeHashCode(this.methodParameter));
	}

	@Override
	public String toString() {
		return (this.field != null ? 
			"field '" + this.field.getName() + "'" : 
			String.valueOf(this.methodParameter));
	}

}

```
#### DependencyDescriptor (依赖描述)
1. 类继承自 InjectionPoint(注入点)
2. 作用: 
    1. 依赖是否必要 required;
       ```
       // required 默认为 true， bean 必须存在，否则报错: Error creating bean with name 'xxx': Unsatisfied
       // required 设置为 false， bean 不存在时跳过，当跳过时不会创建，对象值为 null
       @Autowired(required = false)
       private UserService userService;
       ```
    2. 是否饥饿加载eager;
       ```
       /**
        * 优先级最高
        * 例: ConfigurationClassPostProcessor
        */
       public class UserService implements PriorityOrdered {
       ....
       }
       ```
    3. 嵌套级别 nestingLevel
3. 源码信息
```
package org.springframework.beans.factory.config;

@SuppressWarnings("serial")
public class DependencyDescriptor extends InjectionPoint implements Serializable {

    // 保存所包装依赖(成员属性或者成员方法的某个参数)所在的声明类，
    // 其实该信息在 field/methodParameter 中已经隐含
	private final Class<?> declaringClass;

    // 如果所包装依赖是成员方法的某个参数，则这里记录该成员方法的名称
	@Nullable
	private String methodName;

    // 如果所包装的是成员方法的某个参数，则这里记录该参数的类型
	@Nullable
	private Class<?>[] parameterTypes;

    // 如果所包装的是成员方法的某个参数，则这里记录该参数在该函数参数列表中的索引
	private int parameterIndex;

    //如果所包装的是成员属性，则这里记录该成员属性的名称
	@Nullable
	private String fieldName;

    // 标识所包装依赖是否必要依赖
	private final boolean required;

    // 标识所包装依赖是否需要饥饿加载
	private final boolean eager;

    // 标识所包装依赖的嵌套级别
	private int nestingLevel = 1;

    // 标识所包装依赖的包含者类，通常和声明类是同一个
	@Nullable
	private Class<?> containingClass;

    // 所包装依赖 ResolvableType 的缓存
	@Nullable
	private transient volatile ResolvableType resolvableType;

    // 所包装依赖 TypeDescriptor 的缓存
	@Nullable
	private transient volatile TypeDescriptor typeDescriptor;


	/**
	 * Create a new descriptor for a method or constructor parameter.
	 * Considers the dependency as 'eager'.
     * 构造函数，包装成员方法参数依赖，依赖解析会使用 饥饿模式
	 * @param methodParameter the MethodParameter to wrap
	 * @param required whether the dependency is required
	 */
	public DependencyDescriptor(MethodParameter methodParameter, boolean required) {
		this(methodParameter, required, true);
	}

	/**
	 * Create a new descriptor for a method or constructor parameter.
     * 构造函数，包装成员方法参数依赖
	 * @param methodParameter the MethodParameter to wrap
	 * @param required whether the dependency is required
	 * @param eager whether this dependency is 'eager' in the sense of
	 * eagerly resolving potential target beans for type matching
	 */
	public DependencyDescriptor(MethodParameter methodParameter, boolean required, boolean eager) {
		super(methodParameter);

		this.declaringClass = methodParameter.getDeclaringClass();
		if (methodParameter.getMethod() != null) {
			this.methodName = methodParameter.getMethod().getName();
		}
		this.parameterTypes = methodParameter.getExecutable().getParameterTypes();
		this.parameterIndex = methodParameter.getParameterIndex();
		this.containingClass = methodParameter.getContainingClass();
		this.required = required;
		this.eager = eager;
	}

	/**
	 * Create a new descriptor for a field.
	 * Considers the dependency as 'eager'.
     * 构造函数，包装成员属性依赖，依赖解析会使用 饥饿模式
	 * @param field the field to wrap
	 * @param required whether the dependency is required
	 */
	public DependencyDescriptor(Field field, boolean required) {
		this(field, required, true);
	}

	/**
	 * Create a new descriptor for a field.
	 * @param field the field to wrap
	 * @param required whether the dependency is required
	 * @param eager whether this dependency is 'eager' in the sense of
	 * eagerly resolving potential target beans for type matching
	 */
	public DependencyDescriptor(Field field, boolean required, boolean eager) {
		super(field);

		this.declaringClass = field.getDeclaringClass();
		this.fieldName = field.getName();
		this.required = required;
		this.eager = eager;
	}

	/**
	 * Copy constructor. 复制构造函数
	 * @param original the original descriptor to create a copy from
	 */
	public DependencyDescriptor(DependencyDescriptor original) {
		super(original);

		this.declaringClass = original.declaringClass;
		this.methodName = original.methodName;
		this.parameterTypes = original.parameterTypes;
		this.parameterIndex = original.parameterIndex;
		this.fieldName = original.fieldName;
		this.containingClass = original.containingClass;
		this.required = original.required;
		this.eager = original.eager;
		this.nestingLevel = original.nestingLevel;
	}


	/**
	 * Return whether this dependency is required.
	 * Optional semantics are derived from Java 8's  java.util.Optional,
	 * any variant of a parameter-level  Nullable annotation (such as from
	 * JSR-305 or the FindBugs set of annotations), or a language-level nullable
	 * type declaration in Kotlin.    
	 */
	public boolean isRequired() {
		if (!this.required) {
			return false;
		}

		if (this.field != null) {
			return !(this.field.getType() == Optional.class || hasNullableAnnotation() ||
					(KotlinDetector.isKotlinReflectPresent() &&
							KotlinDetector.isKotlinType(this.field.getDeclaringClass()) &&
							KotlinDelegate.isNullable(this.field)));
		}
		else {
			return !obtainMethodParameter().isOptional();
		}
	}

	/**
	 * Check whether the underlying field is annotated with any variant of a
	 *  Nullable annotation, e.g.  javax.annotation.Nullable or
	 *  edu.umd.cs.findbugs.annotations.Nullable.
	 */
	private boolean hasNullableAnnotation() {
		for (Annotation ann : getAnnotations()) {
			if ("Nullable".equals(ann.annotationType().getSimpleName())) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Return whether this dependency is 'eager' in the sense of
	 * eagerly resolving potential target beans for type matching.
	 */
	public boolean isEager() {
		return this.eager;
	}

	/**
	 * Resolve the specified not-unique scenario: by default,
	 * throwing a  NoUniqueBeanDefinitionException.
	 * Subclasses may override this to select one of the instances or
	 * to opt out with no result at all through returning  null.
	 * @param type the requested bean type
	 * @param matchingBeans a map of bean names and corresponding bean
	 * instances which have been pre-selected for the given type
	 * (qualifiers etc already applied)
	 * @return a bean instance to proceed with, or  null for none
	 * @throws BeansException in case of the not-unique scenario being fatal
	 * @since 5.1
	 */
	@Nullable
	public Object resolveNotUnique(ResolvableType type, Map<String, Object> matchingBeans) 
		throws BeansException {
		throw new NoUniqueBeanDefinitionException(type, matchingBeans.keySet());
	}

	/**
	 * Resolve the specified not-unique scenario: by default,
	 * throwing a  NoUniqueBeanDefinitionException.
	 * Subclasses may override this to select one of the instances or
	 * to opt out with no result at all through returning  null.
	 * @param type the requested bean type
	 * @param matchingBeans a map of bean names and corresponding bean
	 * instances which have been pre-selected for the given type
	 * (qualifiers etc already applied)
	 * @return a bean instance to proceed with, or  null for none
	 * @throws BeansException in case of the not-unique scenario being fatal
	 * @since 4.3
	 * @deprecated as of 5.1, in favor of  #resolveNotUnique(ResolvableType, Map)
	 */
	@Deprecated
	@Nullable
	public Object resolveNotUnique(Class<?> type, Map<String, Object> matchingBeans) 
		throws BeansException {
		throw new NoUniqueBeanDefinitionException(type, matchingBeans.keySet());
	}

	/**
	 * Resolve a shortcut for this dependency against the given factory, for example
	 * taking some pre-resolved information into account.
	 * The resolution algorithm will first attempt to resolve a shortcut through this
	 * method before going into the regular type matching algorithm across all beans.
	 * Subclasses may override this method to improve resolution performance based on
	 * pre-cached information while still receiving  InjectionPoint exposure etc.
	 * @param beanFactory the associated factory
	 * @return the shortcut result if any, or  null if none
	 * @throws BeansException if the shortcut could not be obtained
	 * @since 4.3.1
	 */
	@Nullable
	public Object resolveShortcut(BeanFactory beanFactory) throws BeansException {
		return null;
	}

	/**
	 * Resolve the specified bean name, as a candidate result of the matching
	 * algorithm for this dependency, to a bean instance from the given factory.
	 * 
     * 使用指定的容器 beanFactory 获取所包装依赖对应的 bean 实例
     * 该方法会被容器用于自动注入依赖前获取该依赖所对应的 bean 实例
     * The default implementation calls  BeanFactory#getBean(String).
	 * Subclasses may provide additional arguments or other customizations.
	 * @param beanName the bean name, as a candidate result for this dependency
	 * @param requiredType the expected type of the bean (as an assertion)
	 * @param beanFactory the associated factory
	 * @return the bean instance (never  null)
	 * @throws BeansException if the bean could not be obtained
	 * @since 4.3.2
	 * @see BeanFactory#getBean(String)
	 */
	public Object resolveCandidate(String beanName, Class<?> requiredType, BeanFactory beanFactory)
			throws BeansException {

		return beanFactory.getBean(beanName);
	}


	/**
	 * Increase this descriptor's nesting level.
	 * @see MethodParameter#increaseNestingLevel()
	 */
	public void increaseNestingLevel() {
		this.nestingLevel++;
		this.resolvableType = null;
		if (this.methodParameter != null) {
			this.methodParameter.increaseNestingLevel();
		}
	}

	/**
	 * Optionally set the concrete class that contains this dependency.
	 * This may differ from the class that declares the parameter/field in that
	 * it may be a subclass thereof, potentially substituting type variables.
	 * @since 4.0
	 */
	public void setContainingClass(Class<?> containingClass) {
		this.containingClass = containingClass;
		this.resolvableType = null;
		if (this.methodParameter != null) {
			GenericTypeResolver.resolveParameterType(this.methodParameter, containingClass);
		}
	}

	/**
	 * Build a  ResolvableType object for the wrapped parameter/field.
	 * @since 4.0
	 */
	public ResolvableType getResolvableType() {
		ResolvableType resolvableType = this.resolvableType;
		if (resolvableType == null) {
			resolvableType = (this.field != null ?
					ResolvableType.forField(this.field, this.nestingLevel, this.containingClass) :
					ResolvableType.forMethodParameter(obtainMethodParameter()));
			this.resolvableType = resolvableType;
		}
		return resolvableType;
	}

	/**
	 * Build a  TypeDescriptor object for the wrapped parameter/field.
	 * @since 5.1.4
	 */
	public TypeDescriptor getTypeDescriptor() {
		TypeDescriptor typeDescriptor = this.typeDescriptor;
		if (typeDescriptor == null) {
			typeDescriptor = (this.field != null ?
					new TypeDescriptor(getResolvableType(), getDependencyType(), getAnnotations()) :
					new TypeDescriptor(obtainMethodParameter()));
			this.typeDescriptor = typeDescriptor;
		}
		return typeDescriptor;
	}

	/**
	 * Return whether a fallback match is allowed.
	 * This is  false by default but may be overridden to return  true in order
	 * to suggest to an org.springframework.beans.factory.support.AutowireCandidateResolver
	 * that a fallback match is acceptable as well.
	 * @since 4.0
	 */
	public boolean fallbackMatchAllowed() {
		return false;
	}

	/**
	 * Return a variant of this descriptor that is intended for a fallback match.
	 * @since 4.0
	 * @see #fallbackMatchAllowed()
	 */
	public DependencyDescriptor forFallbackMatch() {
		return new DependencyDescriptor(this) {
			@Override
			public boolean fallbackMatchAllowed() {
				return true;
			}
		};
	}

	/**
	 * Initialize parameter name discovery for the underlying method parameter, if any.
	 * This method does not actually try to retrieve the parameter name at
	 * this point; it just allows discovery to happen when the application calls
	 * #getDependencyName() (if ever).
	 */
	public void initParameterNameDiscovery(@Nullable ParameterNameDiscoverer parameterNameDiscoverer) {
		if (this.methodParameter != null) {
			this.methodParameter.initParameterNameDiscovery(parameterNameDiscoverer);
		}
	}

	/**
	 * Determine the name of the wrapped parameter/field.
	 * @return the declared name (never  null)
	 */
	@Nullable
	public String getDependencyName() {
		return (this.field != null ? 
				this.field.getName() : 
				obtainMethodParameter().getParameterName());
	}

	/**
	 * Determine the declared (non-generic) type of the wrapped parameter/field.
	 * @return the declared type (never null)
	 */
	public Class<?> getDependencyType() {
		if (this.field != null) {
			if (this.nestingLevel > 1) {
				Type type = this.field.getGenericType();
				for (int i = 2; i <= this.nestingLevel; i++) {
					if (type instanceof ParameterizedType) {
						Type[] args = ((ParameterizedType) type).getActualTypeArguments();
						type = args[args.length - 1];
					}
				}
				if (type instanceof Class) {
					return (Class<?>) type;
				}
				else if (type instanceof ParameterizedType) {
					Type arg = ((ParameterizedType) type).getRawType();
					if (arg instanceof Class) {
						return (Class<?>) arg;
					}
				}
				return Object.class;
			}
			else {
				return this.field.getType();
			}
		}
		else {
			return obtainMethodParameter().getNestedParameterType();
		}
	}


	@Override
	public boolean equals(Object other) {
		if (this == other) {
			return true;
		}
		if (!super.equals(other)) {
			return false;
		}
		DependencyDescriptor otherDesc = (DependencyDescriptor) other;
		return (this.required == otherDesc.required && this.eager == otherDesc.eager &&
				this.nestingLevel == otherDesc.nestingLevel 
				&& this.containingClass == otherDesc.containingClass);
	}

	@Override
	public int hashCode() {
		return 31 * super.hashCode() + ObjectUtils.nullSafeHashCode(this.containingClass);
	}


	//---------------------------------------------------------------------
	// Serialization support
	//---------------------------------------------------------------------

	private void readObject(ObjectInputStream ois) throws IOException, ClassNotFoundException {
		// Rely on default serialization; just initialize state after deserialization.
		ois.defaultReadObject();

		// Restore reflective handles (which are unfortunately not serializable)
		try {
			if (this.fieldName != null) {
				this.field = this.declaringClass.getDeclaredField(this.fieldName);
			}
			else {
				if (this.methodName != null) {
					this.methodParameter = new MethodParameter(
							this.declaringClass.getDeclaredMethod(this.methodName, 
																this.parameterTypes), 
							this.parameterIndex);
				}
				else {
					this.methodParameter = new MethodParameter(
							this.declaringClass.getDeclaredConstructor(this.parameterTypes), 
							this.parameterIndex);
				}
				for (int i = 1; i < this.nestingLevel; i++) {
					this.methodParameter.increaseNestingLevel();
				}
			}
		}
		catch (Throwable ex) {
			throw new IllegalStateException("Could not find original class structure", ex);
		}
	}


	/**
	 * Inner class to avoid a hard dependency on Kotlin at runtime.
	 */
	private static class KotlinDelegate {

		/**
		 * Check whether the specified {@link Field} represents a nullable Kotlin type or not.
		 */
		public static boolean isNullable(Field field) {
			KProperty<?> property = ReflectJvmMapping.getKotlinProperty(field);
			return (property != null && property.getReturnType().isMarkedNullable());
		}
	}

}
```
#### ConstructorResolver (构造方法注入)





