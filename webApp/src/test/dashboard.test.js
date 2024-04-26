// Mock data for testing
const mockUserData = [{ id: 1, name: 'John' }, { id: 2, name: 'Jane' }];
const mockHealthData = { userId: 1, data: 'mock health data' };
const mockUserCount = { count: 10 };
const mockProjectCount = { projectCount: 5 };
const mockAgeDemographics = [
  { _id: '18-24', count: 20 },
  { _id: '25-34', count: 15 },
];
const mockGenderDemographics = [
  { _id: 'Male', count: 30 },
  { _id: 'Female', count: 25 },
];

// Mocking the functions to be tested
const getUsers = async () => mockUserData;
const getUserHealthData = async () => mockHealthData;
const getUserCount = async () => mockUserCount;
const getProjectCount = async () => mockProjectCount;
const getUserAgeDemographics = async () => mockAgeDemographics;
const getUserGenderDemographics = async () => mockGenderDemographics;

// Unit tests
test('getUsers - success', async () => {
  const result = await getUsers();
  expect(result).toEqual(mockUserData);
});

test('getUserHealthData - success', async () => {
  const result = await getUserHealthData();
  expect(result).toEqual(mockHealthData);
});

test('getUserCount - success', async () => {
  const result = await getUserCount();
  expect(result).toEqual(mockUserCount);
});

test('getProjectCount - success', async () => {
  const result = await getProjectCount();
  expect(result).toEqual(mockProjectCount);
});

test('getUserAgeDemographics - success', async () => {
  const result = await getUserAgeDemographics();
  expect(result).toEqual(mockAgeDemographics);
});

test('getUserGenderDemographics - success', async () => {
  const result = await getUserGenderDemographics();
  expect(result).toEqual(mockGenderDemographics);
});
