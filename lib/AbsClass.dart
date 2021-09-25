abstract class Animal {
 // String name;

  Animal();

   Animal.fromName(int i);

}

class Dog extends Animal {

 // Dog.withName(String name) : super.fromName(name);

  Dog fromName(int i) {return Dog();}
}

main(){

  var dog = Dog();
  dog.fromName(0);

}