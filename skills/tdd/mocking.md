# When to Mock

Mock at **system boundaries** only:

- Hardware and devices
- Third-party services and libraries
- Network peers and other processes
- Databases (sometimes - prefer a real one)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```cpp
// Easy to mock: the device is passed in
Status configure(Port& p, DeviceIo& io) {
  return io.write(p.base + CTRL, p.flags);
}

// Hard to mock: the device is created inside
Status configure(Port& p) {
  PciDeviceIo io(open_device(p.bdf));
  return io.write(p.base + CTRL, p.flags);
}
```

**2. Prefer specific operations over one generic pass-through**

Create specific functions for each external operation instead of one generic function:

```python
# GOOD: Each function is independently mockable
class SensorBus:
    def read_temperature(self) -> float: ...
    def set_sample_rate(self, hz: int): ...

# BAD: Mocking requires conditional logic inside the mock
class SensorBus:
    def transfer(self, reg: int, data: bytes) -> bytes: ...
```

The specific-operations approach means:
- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which operations a test exercises
- Type safety per operation
