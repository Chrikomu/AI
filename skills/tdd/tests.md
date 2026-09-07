# Good and Bad Tests

## Good Tests

**Integration-style**: Test through real interfaces, not mocks of internal parts.

```python
# GOOD: Tests observable behavior
def test_parser_accepts_frame_with_valid_checksum():
    frame = build_frame(payload=b"\x01\x02", checksum=0x1F)
    result = parse_frame(frame)
    assert result.status == FrameStatus.OK
    assert result.payload == b"\x01\x02"
```

Characteristics:

- Tests behavior users/callers care about
- Uses the public interface only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion per test

## Bad Tests

**Implementation-detail tests**: Coupled to internal structure.

```cpp
// BAD: Tests implementation details
TEST(Parser, CallsChecksumValidator) {
  MockChecksumValidator validator;
  EXPECT_CALL(validator, validate(_)).Times(1);
  Parser parser(&validator);
  parser.parse(frame);
}
```

Red flags:

- Mocking internal collaborators
- Testing private methods or static helpers
- Asserting on call counts/order
- Test breaks when refactoring without behavior change
- Test name describes HOW not WHAT
- Verifying through external means instead of interface

```cpp
// BAD: Bypasses interface to verify
TEST(RingBuffer, PushWritesToSlot) {
  RingBuffer<int, 8> buf;
  buf.push(42);
  EXPECT_EQ(buf.storage_[0], 42);   // reaches into private state
}

// GOOD: Verifies through interface
TEST(RingBuffer, PushedValueCanBePopped) {
  RingBuffer<int, 8> buf;
  buf.push(42);
  EXPECT_EQ(buf.pop(), 42);
}
```

**Tautological tests**: Expected value restates the implementation, so the test passes by construction.

```python
# BAD: Expected value is recomputed the way the code computes it
def test_total_length_sums_segments():
    segments = [Segment(length=10), Segment(length=5)]
    expected = sum(s.length for s in segments)
    assert total_length(segments) == expected

# GOOD: Expected value is an independent, known literal
def test_total_length_sums_segments():
    assert total_length([Segment(length=10), Segment(length=5)]) == 15
```
