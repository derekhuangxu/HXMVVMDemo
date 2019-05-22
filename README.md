# iOS开发中 MVVM 设计模式的探究
## 前言
一直在做一线的业务开发工作，每天接触业务线，时间久了就开始思考如何能优化架构、提高维护效率，于是就接触了`MVVM`。

MVVM的出现主要是为了解决在开发过程中Controller越来越庞大的问题，变得难以维护，所以MVVM把数据加工的任务从Controller中解放了出来，使得Controller只需要专注于具体业务的工作，ViewModel则去负责数据加工并通过各种通知机制让View响应ViewModel的改变。

    还有一个让人很容易忽略的问题，大部分国内外资料阐述MVVM的时候都是这样排布的：Model - View - ViewModel ,
    客观上造成了MVVM不需要Controller的错觉，可事实上是这样的么？

----
## 分析使用逻辑
### ViewModel部分
我最开始听说**MVVM**的时候是一脸懵逼的，因为我在这几个子母中间没有看到Controller的影子，我对于Controller的使用逻辑一无所知。但是直觉告诉我，Controller依然还是不可获取的一部分，至少操作View的时候还是会需要。**ViewModel**这个单词本身也让我产生了困扰，这个术语本身可能导致混乱，因为它是我们已经知道的两个术语的混搭，不知道这个结构更偏向于**View**和**Model**哪一边。

当我查阅资料的时候，网上大部分的MVVM的表述都是`View <-> ViewModel <-> Model`，都是在说ViewModel支持数据的双向绑定，表述模糊，我还是不能完全明白`ViewModel`的真正用处和存在意义。

比如像下面的说法：

> 它将model信息转变为view需要的信息，同时还将命令从view传递到model。View与Model通过ViewModel实现双向绑定。

<!--ViewModel是和Model(数据层)进行交互，并且ViewMode可以被View观察。ViewModel可以选择性地为视图提供钩子以将事件传递给模型，该层的一个重要实现策略是将Model与View分离，即ViewModel不应该意识到与谁交互的视图。-->

我的着眼点放在了上面的第一句话上，即“`它将model信息转变为view信息，同时还将命令从view传递到model`”。当我进一步去理解**ViewModel**的作用的时候，我发现ViewModel更应该被称呼作为“**View与Model中间的观察协调器**”，它主要作用是拿到原始的数据，根据具体业务逻辑需要进行处理，之后将处理好的东西塞到View中去，其职责之一是静态模型，表示View显示自身所需的数据，这使View具有更清晰定义的任务，即呈现视图模型提供的数据，总结为一句话就是**与View直接对应的Model，逻辑上是属于Model层**。


### Controller部分
> 那么Controller的作用呢？

MVVM其实是是基于胖Model的架构思路建立的，然后在胖Model中拆出两部分：Model和ViewModel。
即`MVC -> 胖Model -> Model+ ViewModel`这个演化过程。

和上文分析一致，ViewModel本质上算是Model层（作为与View显示自己所直接对应的Model），所以View并不适合直接持有ViewModel，反之则可以。因为ViewModel有可能并不是一定只服务于特定的一个View，使用更加松散的绑定关系能够降低ViewModel和View之间的耦合度。现在可以说，Controller唯一关注的是使用来自ViewModel的数据配置和管理各种View，Controller的作用就是负责控制**View**和**ViewModel**的绑定和调用关系，Controller**不需要**了解Web服务调用，Core Data，model对象等，这些都是可以丢给ViewModel去操作。

以下2张图或许有更直观的感受：

![](https://user-gold-cdn.xitu.io/2019/5/8/16a93467d920551e?w=376&h=212&f=svg&s=3982)

![](https://user-gold-cdn.xitu.io/2019/5/9/16a98841446de26f?w=392&h=123&f=svg&s=2950)

> 图片来源：http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/

我来解释一下图片指代的意思：

1. MVVM中的View本质上代指的是View和Controller两部分结构。
2. 而MVVM中的ViewModel则是抽离了Controller的一些业务出来组成了ViewModel，同时Controller的工作量减小了很多。
3. 当Controller抽离出来ViewModel之后，MVVM中View也可以区分为View和Controller两部分之后，就成了第二张图**MVCVM**的结构，Controller的代销也就变小了。

所以说，归根结底**MVVM**更应该被形容为`View <-> C <-> ViewModel <-> Model`，即**MVCVM**的设计模式，这样就很清晰的解释了Controller的位置以及作用。


## 进一步梳理

通过以上，我们可以逻辑上得出，Controller应该是持有了ViewModel和View，并对二者进行判断和匹配操作。ViewModel有可能并不是一定只服务于特定的一个View，Controller当中也会有很多的View，所以，同一个Controller可能持有很多个ViewModel，以此来实现不同的业务逻辑控制多重的View。

Controller唯一关注的是使用来自ViewModel的数据配置和管理各种View，并让ViewModel知道何时发生需要更改上游数据的相关用户输入。 Controller不需要知道网络请求、数据库操作以及Model等，这样就让Controller更集中的去处理具体的业务逻辑。
![](https://user-gold-cdn.xitu.io/2019/5/13/16ab051be8baa492?w=800&h=223&f=svg&s=3941)
> 图片来源：http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/

* Controller：负责View和ViewModel之间的调配和绑定关系，执行业务逻辑。
* View：展示UI，接受Action。
* ViewModel：网络请求，数据加工，数据持有。
* Model：原始数据。

大致会形成以下调用关系：
![图片一](https://user-gold-cdn.xitu.io/2019/5/13/16ab0b7d9fedbc4f?imageView2/2/w/480/h/480/q/85/interlace/1)
![图片二](https://user-gold-cdn.xitu.io/2019/5/13/16ab0b87cca96d3d?imageView2/2/w/480/h/480/q/85/interlace/1)

## 代码演示

废话不多说，先上Demo：https://github.com/derekhuangxu/HXMVVMDemo 

下面我会摘出部分重要代码，给大家讲解一下具体的逻辑


### MarshalModel
    
    MarshalModel.h
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, assign) NSInteger lessonCount;
    
Model相对来说就比较简单了，用来储存原始数据。

---------------------

### MarshalViewModel
    
    MarshalViewModel.h
    
    @interface MarshalViewModel : NSObject
    @property (nonatomic, strong, readonly) NSString *name;
    @property (nonatomic, strong, readonly) NSString *detailTextString;
    @property (nonatomic, assign, readonly) UITableViewCellAccessoryType cellType;
    - (instancetype)initWithModel:(MarshalModel *)model;
    @end
    
    MarshalViewModel.m
    
    @interface MarshalViewModel ()
    @property (nonatomic, strong) NSString *name;
    @property (nonatomic, strong) NSString *detailTextString;
    @property (nonatomic, assign) UITableViewCellAccessoryType cellType;
    @end

    @implementation MarshalViewModel

    //依赖注入
    - (instancetype)initWithModel:(MarshalModel *)model ; {
    	if (self = [super init]) {
    		self.name = model.name;
    		if (model.lessonCount > 35) {
    			self.detailTextString = @"多于30门课程";
    			self.cellType = UITableViewCellAccessoryDetailDisclosureButton;
    		} else {
    			self.detailTextString = [NSString stringWithFormat:@"课程数量:%ld", (long)model.lessonCount];
    			self.cellType = UITableViewCellAccessoryNone;
    		}
    	}
    	return self;
    }

* ViewModel的.h文件中，只放置了初始化的代码，执行Model数据的注入，另外提供了向View暴露的接口，这部分要注意了，要加上`readonly`的标示符，当然也可以用`GET`方法代替，这样可以避免View修改ViewModel中的数据，保证**数据从一条线注入，处理之后，从另一条线取出**。
* ViewModel的.m文件，可以说是对于原始数据的处理操作，这里基本上就是对于原始数据转化为View需要数据的处理。当然，大家也可以根据自己的需要增加Cache或者数据库等的操作，也可以增加网络数据获取的操作。

---------------------------
### MarshalCell

    MarshalCell.h
    @interface MarshalCell : UITableViewCell
    @property (nonatomic, strong) MarshalViewModel *viewModel;
    @end
    
    MarshalCell.m
    - (void)setViewModel:(MarshalViewModel *)viewModel {
    	_viewModel = viewModel;
	    self.textLabel.text = viewModel.name;
	    self.detailTextLabel.text = viewModel.detailTextString;
	    self.accessoryType = viewModel.cellType;
    }

我只把.m文件中的`SET`方法给大家展示出来了，我觉得就可以说明问题，ViewModel中提供了View需要的一切处理好的关键要素，那么View就会变得非常扁平，只需要处理点击这种的Action事件，并且传递给Controller即可，不需要关注原始数据转换的具体业务逻辑。

------------------------
### HomeViewController
    HomeViewController.m
    
    @interface HomeViewController () 
    @property (nonatomic, strong) NSMutableArray <MarshalViewModel *>*viewModels;
    @end

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    	MarshalCell *cell = [[MarshalCell alloc] initWithStyle: UITableViewCellStyleSubtitle
    					       reuseIdentifier: kMarshalCellIdentifier];
    	cell.viewModel = self.viewModels[indexPath.row];
    	return cell;
    }

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    	return self.viewModels.count;
    }

    - (void)getData {
    	[[MarshalService shareInstance]fetchDataCompletion:^(NSArray<MarshalModel *> * _Nonnull data) {
	    	self.viewModels = [self viewModelsWithDatas:[data mutableCopy]];
	    	dispatch_async(dispatch_get_main_queue(), ^{
	    		[self.tableView reloadData];
    		});
    	} failure:^(NSError * _Nonnull error) {
    		NSLog(@"Failed to fetch courses:%@", error);
    	}];
    }

大家可以看到，我用了**数组**来储存的ViewModel，原因是因为每个Cell所对应的的数据不一致导致UI展示不一致，所以每个Cell要有一个自己的ViewModel来填充自己UI数据。这就进一步印证了上面说的，**ViewModel本质仍然是Model层**。

## 疑问点（不定期更新）

1、为什么View没有.h接口的可读处理，而ViewModel中要有？
    
    在ViewModel中数据单向注入，之后会有数据根据业务逻辑处理，之后向View提供数据接口，为了保证数据不会被污染，所以增加了`readonly`的标示符，而View中则不需要以上的逻辑。

2、当点击某个Cell的某部分之后，如何向后传值？

    1.Controller找到对应的ViewModel，ViewModel作为Mother ViewModel，替代Controller做一个脏活，去生成相对应的Child ViewModel。
    2.ViewModel将Child ViewModel返回给Controller。
    3.Controller利用Child ViewModel生成下一页面的Controller，执行跳转操作。

## Refrence
* [ReactiveCocoa and MVVM, an Introduction](http://www.sprynthesis.com/2014/12/06/reactivecocoa-mvvm-introduction/)
* [iOS应用架构谈 view层的组织和调用方案](https://casatwy.com/iosying-yong-jia-gou-tan-viewceng-de-zu-zhi-he-diao-yong-fang-an.html)

 ## 另外

  *  [简书地址](http://www.jianshu.com/u/ac41d8480d04)
  *  [掘金地址](https://juejin.im/user/5730b373f38c840067d0d602)
