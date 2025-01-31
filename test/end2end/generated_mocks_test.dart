import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'foo.dart';
import 'generated_mocks_test.mocks.dart';

@GenerateMocks([
  Foo,
  FooSub,
  Bar
], customMocks: [
  MockSpec<Foo>(as: #MockFooRelaxed, returnNullOnMissingStub: true),
  MockSpec<Bar>(as: #MockBarRelaxed, returnNullOnMissingStub: true),
])
void main() {
  group('for a generated mock,', () {
    late MockFoo<Object> foo;
    late FooSub fooSub;

    setUp(() {
      foo = MockFoo();
      fooSub = MockFooSub();
    });

    test('a method with a positional parameter can be stubbed', () {
      when(foo.positionalParameter(42)).thenReturn('Stubbed');
      expect(foo.positionalParameter(42), equals('Stubbed'));
    });

    test('a method with a named parameter can be stubbed', () {
      when(foo.namedParameter(x: 42)).thenReturn('Stubbed');
      expect(foo.namedParameter(x: 42), equals('Stubbed'));
    });

    test('a getter can be stubbed', () {
      when(foo.getter).thenReturn('Stubbed');
      expect(foo.getter, equals('Stubbed'));
    });

    test('an operator can be stubbed', () {
      when(foo + 1).thenReturn(0);
      expect(foo + 1, equals(0));
    });

    test('a method with a parameter with a default value can be stubbed', () {
      when(foo.parameterWithDefault(42)).thenReturn('Stubbed');
      expect(foo.parameterWithDefault(42), equals('Stubbed'));

      when(foo.parameterWithDefault()).thenReturn('Default');
      expect(foo.parameterWithDefault(), equals('Default'));
    });

    test('an inherited method can be stubbed', () {
      when(fooSub.positionalParameter(42)).thenReturn('Stubbed');
      expect(fooSub.positionalParameter(42), equals('Stubbed'));
    });

    test('a setter can be called without stubbing', () {
      expect(() => foo.setter = 7, returnsNormally);
    });

    test('a method which returns void can be called without stubbing', () {
      expect(() => foo.returnsVoid(), returnsNormally);
    });

    test('a method which returns Future<void> can be called without stubbing',
        () {
      expect(() => foo.returnsFutureVoid(), returnsNormally);
    });

    test('a method which returns Future<void>? can be called without stubbing',
        () {
      expect(() => foo.returnsNullableFutureVoid(), returnsNormally);
    });

    test(
        'a method with a non-nullable positional parameter accepts an argument '
        'matcher while stubbing', () {
      when(foo.positionalParameter(any)).thenReturn('Stubbed');
      expect(foo.positionalParameter(42), equals('Stubbed'));
    });

    test(
        'a method with a non-nullable named parameter accepts an argument '
        'matcher while stubbing', () {
      when(foo.namedParameter(x: anyNamed('x'))).thenReturn('Stubbed');
      expect(foo.namedParameter(x: 42), equals('Stubbed'));
    });

    test(
        'a method with a non-nullable parameter accepts an argument matcher '
        'while verifying', () {
      when(foo.positionalParameter(any)).thenReturn('Stubbed');
      foo.positionalParameter(42);
      expect(() => verify(foo.positionalParameter(any)), returnsNormally);
    });

    test('a method with a non-nullable parameter can capture an argument', () {
      when(foo.positionalParameter(any)).thenReturn('Stubbed');
      foo.positionalParameter(42);
      var captured = verify(foo.positionalParameter(captureAny)).captured;
      expect(captured[0], equals(42));
    });

    test('an unstubbed method throws', () {
      when(foo.namedParameter(x: 42)).thenReturn('Stubbed');
      expect(
        () => foo.namedParameter(x: 43),
        throwsA(TypeMatcher<MissingStubError>().having((e) => e.toString(),
            'toString()', contains('namedParameter({x: 43})'))),
      );
    });

    test('an unstubbed getter throws', () {
      expect(
        () => foo.getter,
        throwsA(TypeMatcher<MissingStubError>()
            .having((e) => e.toString(), 'toString()', contains('getter'))),
      );
    });
  });

  group('for a generated mock using returnNullOnMissingStub,', () {
    late Foo<Object> foo;

    setUp(() {
      foo = MockFooRelaxed();
    });

    test('an unstubbed method returning a non-nullable type throws a TypeError',
        () {
      when(foo.namedParameter(x: 42)).thenReturn('Stubbed');
      expect(
          () => foo.namedParameter(x: 43), throwsA(TypeMatcher<TypeError>()));
    });

    test('an unstubbed getter returning a non-nullable type throws a TypeError',
        () {
      expect(() => foo.getter, throwsA(TypeMatcher<TypeError>()));
    });

    test('an unstubbed method returning a nullable type returns null', () {
      when(foo.nullableMethod(42)).thenReturn('Stubbed');
      expect(foo.nullableMethod(43), isNull);
    });

    test('an unstubbed getter returning a nullable type returns null', () {
      expect(foo.nullableGetter, isNull);
    });
  });

  test('a generated mock can be used as a stub argument', () {
    var foo = MockFoo();
    var bar = MockBar();
    when(foo.methodWithBarArg(bar)).thenReturn('mocked result');
    expect(foo.methodWithBarArg(bar), equals('mocked result'));
  });

  test(
      'a generated mock which returns null on missing stubs can be used as a '
      'stub argument', () {
    var foo = MockFooRelaxed();
    var bar = MockBarRelaxed();
    when(foo.methodWithBarArg(bar)).thenReturn('mocked result');
    expect(foo.methodWithBarArg(bar), equals('mocked result'));
  });
}
