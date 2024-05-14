class Estimator {
  TNode head;
  TNode src;
  TNode target;

  Estimator(this.head, this.src, this.target);
}

class TNode {
  int time;

  TNode(this.time);
}

class TEdge {
  double distance;

  TEdge(this.distance);
}