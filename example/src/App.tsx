// If a Swift package framework is NOT embedded the app crashes at launch
// (dyld error) before React Native even starts – this screen never renders.
// When they ARE embedded you see the Alamofire and RiveRuntime versions returned from Swift.
import { Text, View, StyleSheet, useColorScheme } from 'react-native';
import { getVersion } from 'rn-spm-dynamic-poc';

const version = getVersion();

export default function App() {
  const dark = useColorScheme() === 'dark';
  return (
    <View style={[styles.container, { backgroundColor: dark ? '#000' : '#fff' }]}>
      <Text style={[styles.label, { color: dark ? '#fff' : '#000' }]}>SPM dynamic framework demo</Text>
      <Text style={{ color: dark ? '#fff' : '#000' }}>{version}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  label: {
    fontWeight: '600',
    marginBottom: 8,
  },
});
