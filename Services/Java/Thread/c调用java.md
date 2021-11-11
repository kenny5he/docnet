 代码制作参考，具体结合视频结合自己的情况，这里只列出关键代码
 xxxxxx() {
	// 定义用到的变量
	int res;
	JNIEnv *env;
	JavaVMInitArgs vm_args;
	JavaVMOption options[3];
	vm_args.version;
	
	// 设置初始化参数
	options[0].optionString = "-Djava.compiler=NONE";
	//classpath 从哪里去findclass 这里表示当前目录
	options[1].optionString = "-Djava.class.path=.";

	// 版本号设置不能漏
	vm_args.version = JNI_VERSION_1_8;
	vm_args.nOptions = 3;
	vm_args.options = options;
	vm_args.ignoreUnrecognized = JNI_TRUE;
	// 1.初始化虚拟机
	res = JNI_CreateJavaVM(&jvm, (void**)&env, &vm_args);
	
	// 2.获取类
	jclass cls = env->FindClass("你的类");
	// 3.获取类的方法
	jmethodID mid= env->GetMethodID(cls,"你的方法名","()V");
	// 获取Java的构造方法
	jmethodID con=env->GetMethodID(cls,"<init>","()V");//无参构造方法
	//参数，如果无参就不需要自行注释
	jstring strinit = env->NewStringUTF("Still is coding!");
	jvalue arg[1];
	arg[0].l = strinit;
	// 4.创建类的对象,arg 是参数，无参参考视频中我怎么调用的，这里给出有参数的
	jobject obj = env->NewObjectA(cls,con,arg);
	// 调用对象的方法
	jstring msg = (jstring)env-> CallObjectMethod(obj, mid);
	
	
	return 0;
}
