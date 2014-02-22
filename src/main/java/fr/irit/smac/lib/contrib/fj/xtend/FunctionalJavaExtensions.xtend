package fr.irit.smac.lib.contrib.fj.xtend

import fj.Equal
import fj.F
import fj.Ord
import fj.Ordering
import fj.P
import fj.P2
import fj.data.List

class FunctionalJavaExtensions {
	
	@Pure
	static def <A,B> fjFunction(F<A,B> f) {
		f
	}
	
	@Pure
	static def <A> List<A> vary(List<? extends A> l) {
		l as List<A>
	}
	
	@Pure
	@Inline(value="$2.$3iterableList($1)", imported=List)
	static def <A> List<A> toFJList(Iterable<A> l) {
		List.iterableList(l)
	}
	
	@Inline(value="$1.snoc($2)")
	static def <E> List.Buffer<E> operator_add(List.Buffer<E> collection, E value) {
		collection.snoc(value)
	}
	
	@Pure
	@Inline(value="$1.append($2)")
	static def <T> List<T> operator_plus(List<T> a, List<T> b) {
		a.append(b)
	}
	
	@Pure
	@Inline(value="$2.cons($1)")
	static def <T> List<T> operator_plus(T a, List<T> b) {
		b.cons(a)
	}
	
	@Pure
	@Inline(value="$1.snoc($2)")
	static def <T> List<T> operator_plus(List<T> a, T b) {
		a.snoc(b)
	}
	
	@Pure
	@Inline(value="$3.orThen($1,$2)",imported=FunctionalJavaExtensions)
	static def <T> Ord<T> operator_or(Ord<T> a, Ord<T> b) {
		a.orThen(b)
	}
	
	@Pure
	static def <A> int count(List<A> l, F<A, Boolean> f) {
		l.count2(f)._1
	}
	
	/**
	 * returns a pair whose first element is the number of element
	 * for which f returns true, and whose second element is the
	 * number of element for which f returns false.
	 */
	@Pure
	static def <A> P2<Integer,Integer> count2(List<A> l, F<A, Boolean> f) {
		var xs = l
		var i = 0
		var j = 0
		while (xs.notEmpty) {
			val h = xs.head
			if (f.f(h)) {
				i = i+1
			} else {
				j = j+1
			}
			xs = xs.tail
		}
		P.p(i, j)
	}
	
	@Pure
	@Inline(value="$2.$3join($1)", imported=List)
	static def <A> List<A> flatten(List<List<A>> in) {
		List.join(in)
	}
	
	@Pure
	static def <A> Ord<A> inverse(Ord<A> ord) {
		Ord.ord([a|[b|ord.compare(b,a)]])
	}
	
	@Pure
	static def <A> Ord<A> orThen(Ord<A> one, Ord<A> two) {
		Ord.ord([a|[b|
			val o = one.compare(a,b)
			if (o == Ordering.EQ) two.compare(a,b)
			else o
		]])
	}
	
	/**
	 * Will be ordered by ord.max first but equivalent by eq
	 */
	@Pure
	static def <A> List<A> maximums(List<A> in, Equal<A> eq, Ord<A> ord) {
		in.minimums(eq, ord.inverse)
	}
	
	/**
	 * Will be ordered by ord.min first but equivalent by eq
	 */
	@Pure
	static def <A> List<A> minimums(List<A> in, Equal<A> eq, Ord<A> ord) {
		switch in {
			case List.nil: List.nil
			default: {
				val sorted = in.sort(ord)
				val h = sorted.head
				sorted.takeWhile[eq.eq(h,it)]
			}
		}
	}
}