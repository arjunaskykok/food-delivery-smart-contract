pragma solidity ^0.4.23;

contract FoodDelivery {
  address public owner;
  address public customer;
  mapping(string => uint) menu;
  enum OrderingStep { START, ORDERING_FOOD, DELIVERING_FOOD }
  OrderingStep step;

  constructor() public {
    owner = msg.sender;

    menu['sushi'] = 0.1 ether;
    menu['fried_chicken'] = 0.4 ether;
    menu['vegetarian_burger'] = 0.2 ether;

    step = OrderingStep.START;
  }

  function orderFood(string food) public payable {
    require(menu[food] != 0);
    require(msg.value >= menu[food]);

    customer = msg.sender;
    step = OrderingStep.ORDERING_FOOD;
  }

  function cancelOrder() customer_only public {
    require(step == OrderingStep.ORDERING_FOOD);

    customer.transfer(address(this).balance);
    step = OrderingStep.START;
  }

  function startDelivery() restricted public {
    require(step == OrderingStep.ORDERING_FOOD);

    step = OrderingStep.DELIVERING_FOOD;
  }

  function endDelivery() customer_only public {
    require(step == OrderingStep.DELIVERING_FOOD);

    owner.transfer(address(this).balance);

    step = OrderingStep.START;
    customer = 0x0;
  }

  function getOrderStatus() view  public returns (OrderingStep) {
    return step;
  }

  function getMenu() pure  public returns (string) {
    return "sushi, fried_chicken, vegetarian_burger";
  }

  modifier restricted() {
    require(msg.sender == owner);
    _;
  }

  modifier customer_only() {
    require(msg.sender == customer);
    _;
  }

}

